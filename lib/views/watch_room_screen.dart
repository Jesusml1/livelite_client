import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livelite_client/views/widgets/participant.dart';
import 'package:livelite_client/views/widgets/participant_info.dart';
import 'package:livelite_client/views/widgets/viewer_count_widget.dart';
import 'package:livelite_client/views/extensions/exts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WatchStreamView extends StatefulWidget {
  final Room room;
  // final RoomMetadata roomMetadata;
  final EventsListener<RoomEvent> listener;
  final VoidCallback refreshStreamsList;

  const WatchStreamView(
    this.room,
    // this.roomMetadata,
    this.refreshStreamsList,
    this.listener, {
    super.key,
  });

  @override
  State<WatchStreamView> createState() => _WatchStreamViewState();
}

class _WatchStreamViewState extends State<WatchStreamView> {
  List<ParticipantTrack> participantTracks = [];
  EventsListener<RoomEvent> get _listener => widget.listener;
  bool get fastConnection => widget.room.engine.fastConnectOptions != null;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    widget.room.addListener(_onRoomDidUpdate);
    _setUpListeners();
    _sortParticipants();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((timeStamp) {
      if (!fastConnection) {
        // _askPublish();
      }
    });

    if (lkPlatformIsMobile()) {
      Hardware.instance.setSpeakerphoneOn(true);
    }

    if (lkPlatformIs(PlatformType.iOS)) {
      if (kDebugMode) {
        print('ios');
      }
    }
  }

  @override
  void dispose() {
    (() async {
      if (lkPlatformIs(PlatformType.iOS)) {
        if (kDebugMode) {
          print('ios');
        }
      }
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room.dispose();
    })();
    WakelockPlus.disable();
    super.dispose();
  }

  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        if (kDebugMode) {
          print('room disconnected: reason => ${event.reason}');
        }
      }
      WidgetsBindingCompatible.instance?.addPostFrameCallback(
        (timeStamp) => widget.room.disconnect(),
      );
    })
    ..on<ParticipantEvent>((event) {
      // print('participant event');
      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      context.showRecordingStatusChangedDialog(event.activeRecording);
    })
    ..on<RoomAttemptReconnectEvent>((event) {
      if (kDebugMode) {
        print(
          'attemping to reconnect ${event.attempt}/${event.maxAttemptsRetry}'
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)',
        );
      }
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<ParticipantNameUpdatedEvent>((event) {
      // print(
      //     'participant name updated: ${event.participant.identity}, name => ${event.name}');
      _sortParticipants();
    })
    ..on<ParticipantMetadataUpdatedEvent>((event) {
      if (kDebugMode) {
        print(
          'Participant metadata updated: ${event.participant.identity}'
          'Metadata: ${event.metadata}',
        );
      }
    })
    ..on<RoomMetadataChangedEvent>((event) {
      // print('Participant metadata updated: ${event.metadata}');
    })
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (_) {
        // print('failed to decode $_');
      }
      context.showDataReceivedDialog(decoded);
    })
    ..on((event) async {
      if (!widget.room.canPlaybackAudio) {
        bool? yesno = await context.showPlayAudioManuallyDialog();
        if (yesno == true) {
          await widget.room.startAudio();
        }
      }
    });

  // void _askPublish() async {
  //   final result = await context.showPublishDialog();
  //   if (result != true) return;
  //   try {
  //     await widget.room.localParticipant?.setCameraEnabled(true);
  //   } catch (error) {
  //     if (context.mounted) {
  //       await context.showErrorDialog(error);
  //     }
  //   }
  //   try {
  //     await widget.room.localParticipant?.setMicrophoneEnabled(true);
  //   } catch (e) {
  //     if (context.mounted) {
  //       await context.showErrorDialog(e);
  //     }
  //   }
  // }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    for (var participant in widget.room.remoteParticipants.values) {
      for (var t in participant.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(
            ParticipantTrack(
              participant: participant,
              videoTrack: t.track,
              isScreenShare: true,
            ),
          );
        } else {
          userMediaTracks.add(
            ParticipantTrack(
              participant: participant,
              videoTrack: t.track,
              isScreenShare: false,
            ),
          );
        }
      }
    }

    if (!busy && userMediaTracks.isEmpty) {
      setState(() {
        busy = true;
      });
      widget.room.disconnect().then(
        (value) {
          if (mounted) {
            Fluttertoast.showToast(msg: 'Stream ended');
            widget.refreshStreamsList();
            Navigator.of(context).pop();
          }
        },
      );
    }

    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.microsecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.microsecondsSinceEpoch ?? 0;
      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.microsecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipantTracks =
        widget.room.localParticipant?.videoTrackPublications;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        if (t.isScreenShare) {
          if (lkPlatformIs(PlatformType.iOS)) {
            //
          }
        }

        userMediaTracks.add(
          ParticipantTrack(
            participant: widget.room.localParticipant!,
            videoTrack: t.track,
            isScreenShare: false,
          ),
        );
      }
    }

    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          await widget.room.disconnect();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: 
          Text('live now'),
          //  Row(
          //   children: [
          //     AvatarImageWidget(
          //       radius: 20,
          //       uri: widget.roomMetadata.avatarUrl,
          //       username: widget.roomMetadata.username,
          //     ),
          //     const SizedBox(width: 20),
          //     Text(
          //       widget.roomMetadata.username,
          //       style: const TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          actions: [
            ViewersCountWidget(count: widget.room.remoteParticipants.length),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () async {
                await widget.room.disconnect();
                // if (context.mounted) {
                //   Navigator.of(context).pop();
                // }
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: participantTracks.isNotEmpty
                      ? ParticipantWidget.widgetFor(
                          participantTracks.first,
                          showStatsLayer: true,
                          videoViewMirrorMode: VideoViewMirrorMode.auto,
                        )
                      : Container(),
                )
              ],
            ),
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   top: 0,
            //   child: SizedBox(
            //     height: 120,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: math.max(0, participantTracks.length - 1),
            //       itemBuilder: (BuildContext context, int index) => SizedBox(
            //         width: 180,
            //         height: 120,
            //         child: ParticipantWidget.widgetFor(
            //           participantTracks[index + 1],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
