import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livelite_client/views/widgets/stream_chat_section.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFullScreen = false;
  bool _showControls = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controlsTimer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Placeholder for video stream (fullscreen)
              Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "Video Stream (Fullscreen)",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        children: [
          // Video stream container (portrait mode)
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    "Video Stream",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
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
          StreamChatSection(),
        ],
      ),
    );
  }
}
