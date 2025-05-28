import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livelite_client/modules/streaming/models/comment.dart';
import 'package:livelite_client/views/widgets/comment_input_section.dart';
import 'package:livelite_client/views/widgets/participant.dart';
import 'package:livelite_client/views/widgets/participant_info.dart';
// import 'package:livelite_client/views/widgets/viewer_count_widget.dart';
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

  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isFullScreen = false;
  bool _showControls = true;
  Timer? _controlsTimer;

  final List<Comment> _comments = [
    Comment(
      username: "User3",
      text: "I'm learning so much!",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Comment(
      username: "User2",
      text: "How did you do that?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Comment(
      username: "User1",
      text: "Great stream!",
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
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
    _commentController.dispose();
    _scrollController.dispose();
    _controlsTimer?.cancel();
    super.dispose();
  }

  void _setUpListeners() =>
      _listener
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
          print('room is screen sharing...');
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

    // if (!busy && userMediaTracks.isEmpty) {
    //   setState(() {
    //     busy = true;
    //   });
    //   widget.room.disconnect().then((value) {
    //     if (mounted) {
    //       Fluttertoast.showToast(msg: 'Stream ended');
    //       widget.refreshStreamsList();
    //       // Navigator.of(context).pop();
    //     }
    //   });
    // }

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

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        _showControls = true;
        _startHideControlsTimer();
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        _controlsTimer?.cancel();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideControlsTimer();
      } else {
        _controlsTimer?.cancel();
      }
    });
  }

  void _startHideControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isFullScreen) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  // void _addComment() {
  //   if (_commentController.text.isNotEmpty) {
  //     setState(() {
  //       _comments.add(
  //         Comment(
  //           username: "You",
  //           text: _commentController.text,
  //           timestamp: DateTime.now(),
  //         ),
  //       );
  //       _commentController.clear();
  //     });

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   }
  // }

  void _handleNewComment(String text) {
    setState(() {
      _comments.add(
        Comment(username: "You", text: text, timestamp: DateTime.now()),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await widget.room.disconnect();
        }
      },
      child: Builder(
        builder: (context) {
          if (_isFullScreen) {
            return Scaffold(
              body: GestureDetector(
                onTap: _toggleControls,
                child: Stack(
                  children: [
                    // Placeholder for video stream (fullscreen)
                    participantTracks.isNotEmpty
                        ? ParticipantWidget.widgetFor(
                          participantTracks.first,
                          showStatsLayer: true,
                          videoViewMirrorMode: VideoViewMirrorMode.auto,
                        )
                        : Container(),

                    // Fullscreen controls overlay
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Column(
                            children: [
                              // Top controls
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: _toggleFullScreen,
                                      color: Colors.white,
                                    ),
                                    const Text(
                                      "Live Stream",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.fullscreen_exit),
                                      onPressed: _toggleFullScreen,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Bottom controls
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      onPressed: () {
                                        // Play/pause functionality
                                        _startHideControlsTimer();
                                      },
                                      color: Colors.white,
                                      iconSize: 36,
                                    ),
                                    const SizedBox(width: 24),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () {
                                        // Volume control
                                        _startHideControlsTimer();
                                      },
                                      color: Colors.white,
                                      iconSize: 36,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Live Stream")),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Video stream container (portrait mode)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      participantTracks.isNotEmpty
                          ? ParticipantWidget.widgetFor(
                            participantTracks.first,
                            showStatsLayer: true,
                            videoViewMirrorMode: VideoViewMirrorMode.auto,
                          )
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: _toggleFullScreen,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Comments section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                child: Text(comment.username[0]),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          comment.username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTimestamp(comment.timestamp),
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment.text),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Comment input section
                CommentInputSection(onCommentSubmitted: _handleNewComment),
              ],
            ),
          );
        },
      ),
    );

    // return PopScope(
    //   onPopInvokedWithResult: (didPop, _) async {
    //     if (didPop) {
    //       await widget.room.disconnect();
    //     }
    //   },
    //   child: Scaffold(
    //     backgroundColor: Colors.black,
    //     appBar: AppBar(
    //       backgroundColor: Colors.black,
    //       automaticallyImplyLeading: false,
    //       title: Text('live now'),
    //       actions: [
    //         ViewersCountWidget(count: widget.room.remoteParticipants.length),
    //         const SizedBox(width: 20),
    //         IconButton(
    //           onPressed: () async {
    //             await widget.room.disconnect();
    //             // if (context.mounted) {
    //             //   Navigator.of(context).pop();
    //             // }
    //           },
    //           icon: const Icon(Icons.close, color: Colors.white),
    //         ),
    //       ],
    //     ),
    //     body: Stack(
    //       children: [
    //         Column(
    //           children: [
    //             Expanded(
    //               child:
    //                   participantTracks.isNotEmpty
    //                       ? ParticipantWidget.widgetFor(
    //                         participantTracks.first,
    //                         showStatsLayer: true,
    //                         videoViewMirrorMode: VideoViewMirrorMode.auto,
    //                       )
    //                       : Container(),
    //             ),
    //           ],
    //         ),
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
    //       ],
    //     ),
    //   ),
    // );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }
}
