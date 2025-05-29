import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livelite_client/config/config.dart';
// import 'package:livelite_client/modules/models/video_devices_id.dart';
import 'package:livelite_client/modules/streaming/backend/streaming.dart';
import 'package:livelite_client/modules/streaming/game_stream_config.dart';
import 'package:livelite_client/views/screen_capture_room.dart';
import 'package:livelite_client/views/widgets/loading_indicator.dart';
import 'package:nanoid/nanoid.dart';
import 'package:webrtc_interface/webrtc_interface.dart' as webrtc;
// import 'package:livelite_client/config/config.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class PreJoinScreenCapture extends StatefulWidget {
  const PreJoinScreenCapture({super.key});

  @override
  State<PreJoinScreenCapture> createState() => _PreJoinScreenCaptureState();
}

class _PreJoinScreenCaptureState extends State<PreJoinScreenCapture> {
  final String url = Config.livekitUrl;

  bool simulcast = true;
  bool adaptiveStream = true;
  bool dynacast = true;
  String preferredCodec = 'VP8';
  bool enableBackupVideoCodec = true;

  // List<MediaDevice> _audioInputs = [];
  // List<MediaDevice> _videoInputs = [];
  StreamSubscription? _subscription;
  // CameraPosition _selectedCameraPosition = CameraPosition.back;

  bool _busy = false;
  bool _enableVideo = true;
  // bool _enableAudio = true;
  // LocalAudioTrack? _audioTrack;
  // LocalVideoTrack? _videoTrack;
  LocalVideoTrack? _screenTrack;

  // MediaDevice? _selectedVideoDevice;
  // MediaDevice? _selectedAudioDevice;
  // final VideoParameters _selectedVideoParameters =
  //     VideoParametersPresets.h720_169;
  VideoViewMirrorMode videoViewMirrorMode = VideoViewMirrorMode.off;

  bool subsOnlyStream = false;

  @override
  void initState() {
    super.initState();
    // _subscription = Hardware.instance.onDeviceChange.stream.listen(
    //   _loadDevices,
    // );
    // Hardware.instance.enumerateDevices().then(_loadDevices);
    _setEnableVideo(true);
  }

  // void _loadDevices(List<MediaDevice> devices) async {
  //   _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
  //   _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();

  //   if (_audioInputs.isNotEmpty && _selectedAudioDevice == null) {
  //     _selectedAudioDevice = _audioInputs.first;
  //     Future.delayed(const Duration(microseconds: 100), () async {
  //       await _changeLocalAudioTrack();
  //       setState(() {});
  //     });
  //   }

  //   if (_videoInputs.isNotEmpty && _selectedVideoDevice == null) {
  //     _selectedVideoDevice = _videoInputs.first;
  //     Future.delayed(const Duration(microseconds: 100), () async {
  //       await _changeLocalVideoTrack();
  //       setState(() {});
  //     });
  //   }
  // }

  Future<void> _setEnableVideo(value) async {
    _enableVideo = value;
    if (!_enableVideo) {
      // await _videoTrack?.stop();
      await _screenTrack?.stop();
    } else {
      await _changeLocalVideoTrack();
    }
    setState(() {});
  }

  // Future<void> _setEnableAudio(value) async {
  //   _enableAudio = value;
  //   if (!_enableAudio) {
  //     await _audioTrack?.stop();
  //   } else {
  //     await _changeLocalAudioTrack();
  //   }
  //   setState(() {});
  // }

  // Future<void> _changeLocalAudioTrack() async {
  //   if (_audioTrack != null) {
  //     await _audioTrack!.stop();
  //     _audioTrack = null;
  //   }

  //   if (_selectedAudioDevice != null) {
  //     _audioTrack = await LocalAudioTrack.create(
  //       AudioCaptureOptions(deviceId: _selectedAudioDevice!.deviceId),
  //     );
  //     await _audioTrack!.start();
  //   }
  // }

  Future<void> _askForScreenSharingPermission() async {
    if (lkPlatformIs(PlatformType.android)) {
      // Android specific
      bool hasCapturePermission = await Helper.requestCapturePermission();
      if (!hasCapturePermission) {
        return;
      }

      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'LiveKit Example is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.normal,
              notificationIcon: AndroidResource(
                name: 'livekit_ic_launcher',
                defType: 'mipmap',
              ),
            );
            hasPermissions = await FlutterBackground.initialize(
              androidConfig: androidConfig,
            );
          }
          if (hasPermissions &&
              !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
            _screenTrack = await LocalVideoTrack.createScreenShareTrack(
              ScreenShareCaptureOptions(
                // captureScreenAudio: true,
                maxFrameRate: 25,
                params: GameStreamConfig.gamingMobile,
                // params: VideoParametersPresets.screenShareH1080FPS30
                // params: VideoParameters(
                //   dimensions: VideoDimensionsPresets.h1080_169,
                //   encoding: VideoEncoding(
                //     maxFramerate: 30,
                //     maxBitrate: 8000000,
                //   ),
                // ),
              ),
            );
            print('starting screen sharing...');
            await _screenTrack!.start();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(
              const Duration(seconds: 1),
              () => requestBackgroundPermission(true),
            );
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    } else if (lkPlatformIs(PlatformType.iOS)) {
      _screenTrack = await LocalVideoTrack.createScreenShareTrack(
        ScreenShareCaptureOptions(
          captureScreenAudio: true,
          maxFrameRate: 60,
          useiOSBroadcastExtension: true,
        ),
      );
      await _screenTrack!.start();
    }
  }

  Future<void> _changeLocalVideoTrack() async {
    // if (_videoTrack != null) {
    //   await _videoTrack!.stop();
    //   _videoTrack = null;
    // }

    if (_screenTrack != null) {
      await _screenTrack!.stop();
      _screenTrack = null;
    }

    // if (_selectedVideoDevice != null) {
    // _videoTrack = await LocalVideoTrack.createCameraTrack(
    //   CameraCaptureOptions(
    //     deviceId: _selectedVideoDevice!.deviceId,
    //     params: _selectedVideoParameters,
    //     cameraPosition: _selectedCameraPosition,
    //   ),
    // );

    await _askForScreenSharingPermission();

    // _screenTrack = await LocalVideoTrack.createScreenShareTrack(
    //   ScreenShareCaptureOptions(captureScreenAudio: true, maxFrameRate: 30),
    // );
    // print('starting screen sharing...');
    // await _screenTrack!.start();
    // await _videoTrack!.start();
    // }
  }

  // Future<void> _changeSelectedVideoDevice() async {
  //   await _setEnableAudio(false);
  //   await _setEnableVideo(false);

  //   if (_selectedVideoDevice != null) {
  //     if (_selectedVideoDevice!.deviceId == VideoDevicesId.backCamera) {
  //       setState(() {
  //         videoViewMirrorMode = VideoViewMirrorMode.mirror;
  //       });
  //       changeCamera(
  //         deviceId: VideoDevicesId.frontCamera,
  //         cameraPosition: CameraPosition.front,
  //       );
  //     } else {
  //       setState(() {
  //         videoViewMirrorMode = VideoViewMirrorMode.off;
  //       });
  //       changeCamera(
  //         deviceId: VideoDevicesId.backCamera,
  //         cameraPosition: CameraPosition.back,
  //       );
  //     }
  //   }

  //   await _setEnableAudio(true);
  //   await _setEnableVideo(true);
  // }

  // void changeCamera({
  //   required String deviceId,
  //   required CameraPosition cameraPosition,
  // }) {
  //   setState(() {
  //     _selectedVideoDevice = _videoInputs.firstWhere(
  //       (vi) => vi.deviceId == deviceId,
  //     );
  //     _selectedCameraPosition = cameraPosition;
  //   });
  // }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void actionBack(BuildContext context) async {
    await _setEnableVideo(false);
    // await _setEnableAudio(false);
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> getToken() async {
      final token = await generateTokenToJoin(
        nickname: nanoid(10),
        roomName: "screen-capture-test",
      );
      if (token != null) {
        return token;
      }
      return null;
    }

    void join(BuildContext context) async {
      try {
        setState(() {
          _busy = true;
        });

        final room = Room(
          roomOptions: RoomOptions(
            adaptiveStream: adaptiveStream,
            dynacast: dynacast,
            defaultVideoPublishOptions: VideoPublishOptions(
              stream: nanoid(),
              simulcast: simulcast,
              videoCodec: preferredCodec,
              videoEncoding: GameStreamConfig.gamingMobile.encoding,
              backupVideoCodec: BackupVideoCodec(enabled: false),
              degradationPreference: DegradationPreference.maintainFramerate,
            ),
            defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(
              useiOSBroadcastExtension: true,
              params: GameStreamConfig.gamingMobile,
              captureScreenAudio: true,
            ),
            e2eeOptions: null,
          ),
        );

        final listener = room.createListener();
        var token = await getToken();

        await room.connect(
          url,
          token!,
          fastConnectOptions: FastConnectOptions(
            // microphone: TrackOption(track: _audioTrack),
            // camera: TrackOption(track: _videoTrack),
            screen: TrackOption(track: _screenTrack),
          ),
        );

        if (context.mounted) {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder:
                  (_) => ScreenCaptureRoom(
                    room,
                    subsOnlyStream,
                    videoViewMirrorMode,
                    listener,
                  ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('could not join $e');
        }
      } finally {
        setState(() {
          _busy = false;
        });
      }
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          actionBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFFFD700), // Bright Yellow
                  Color(0xFFC4A000),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const Text('startLiveStreamMsg'),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.height - 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          color: const Color.fromARGB(67, 158, 158, 158),
                          alignment: Alignment.center,
                          child:
                              _screenTrack != null
                                  ? VideoTrackRenderer(
                                    _screenTrack!,
                                    fit:
                                        webrtc
                                            .RTCVideoViewObjectFit
                                            .RTCVideoViewObjectFitCover,
                                    mirrorMode: videoViewMirrorMode,
                                  )
                                  : Container(
                                    alignment: Alignment.center,
                                    child: LayoutBuilder(
                                      builder:
                                          (ctx, constrains) => Icon(
                                            Icons.videocam_off,
                                            color: Colors.blue,
                                            size:
                                                math.min(
                                                  constrains.maxHeight,
                                                  constrains.maxWidth,
                                                ) *
                                                0.3,
                                          ),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     const Expanded(child: SizedBox()),
                  //     TextButton(
                  //       onPressed: () async {
                  //         await _changeSelectedVideoDevice();
                  //       },
                  //       child: Row(
                  //         children: [
                  //           const Icon(Icons.flip_camera_android),
                  //           const SizedBox(width: 15),
                  //           const Text('flipCameraBtn'),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Switch(
                  //       value: subsOnlyStream,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           subsOnlyStream = !subsOnlyStream;
                  //         });
                  //       },
                  //     ),
                  //     const SizedBox(width: 10),
                  //     const Text('exclusiveStreamSlider'),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(253, 64, 58, 1),
                          Color.fromARGB(255, 255, 170, 59),
                        ],
                      ),
                    ),
                    child: TextButton(
                      onPressed: _busy ? null : () => join(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_busy)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SizedBox(
                                height: 15,
                                width: 15,
                                child: LoadingIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          const Text(
                            'startBtn',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
