import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livelite_client/modules/streaming/models/comment.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
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
  }

  @override
  void dispose() {
    _commentController.dispose();
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

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(
          Comment(
            username: "You",
            text: _commentController.text,
            timestamp: DateTime.now(),
          ),
        );
        _commentController.clear();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
