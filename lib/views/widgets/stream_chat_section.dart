import 'package:flutter/material.dart';
import 'package:livelite_client/modules/streaming/models/comment.dart';
import 'package:livelite_client/modules/streaming/models/emote.dart';
import 'package:livelite_client/views/misc/emojis.dart';

class StreamChatSection extends StatefulWidget {
  const StreamChatSection({super.key});

  @override
  State<StreamChatSection> createState() => _StreamChatSectionState();
}

class _StreamChatSectionState extends State<StreamChatSection>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isComposing = false;
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;

  // Add a list of available emotes
  final List<Emote> _availableEmotes = [
    Emote(name: "emoteSmiling", url: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWRpZXlvc29wMHU5OTNkYWs4MHU2cjhiNXRnZzJ5MXZ4N2k3dGV4MCZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9dHM/Ee66WjrGWmOe38elCo/giphy.gif"),
    Emote(name: "emoteDoge", url: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa3RsbDV0MTc5MGhtenozam8zbTF0cHc5MGVmcHRqMDhueTMxMG0wOCZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9cw/nFyixvuEJ4WLAPrC4b/giphy.gif"),
    Emote(name: "emoteCry", url: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExM2p1bTM2aWYzdzFsc25uOWNubHdzZGoxazF3aWtrcHVrazI1ZDR3cyZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9cw/Xr9TlAqw3S7VPOrftK/giphy.gif"),
    Emote(name: "emoteFire", url: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa3d2NnJ3MG92c2t2eG05aWM3b3l6ZDI0bm00NWJnNXd3NjBxdm50dSZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9cw/l1J9QZXasDUhbX0fC/giphy.gif"),
    Emote(name: "emoteCat", url: "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa2ZrNWVvaWoybGwzZXYwNHR5anNwa3cwbGR6bWR1NWFhamtvZ3dmYSZlcD12MV9zdGlja2Vyc19zZWFyY2gmY3Q9cw/bjE9JbNSckM0w/giphy.gif"),
  ];

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
    _focusNode.addListener(_onFocusChange);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        // Hide keyboard when showing emoji picker
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  void _insertEmoji(String emoji) {
    final text = _commentController.text;
    final textSelection = _commentController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      emoji,
    );

    final emojiLength = emoji.length;
    _commentController.text = newText;
    _commentController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + emojiLength,
      extentOffset: textSelection.start + emojiLength,
    );

    setState(() {
      _isComposing = _commentController.text.trim().isNotEmpty;
    });
  }

  // Add a method to insert an emote code
  void _insertEmoteCode(String emoteName) {
    final text = _commentController.text;
    final textSelection = _commentController.selection;
    final emoteCode = ":$emoteName:";
    
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      emoteCode,
    );

    final emoteCodeLength = emoteCode.length;
    _commentController.text = newText;
    _commentController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + emoteCodeLength,
      extentOffset: textSelection.start + emoteCodeLength,
    );

    setState(() {
      _isComposing = _commentController.text.trim().isNotEmpty;
    });
  }

  void _handleNewComment(String text) {
    setState(() {
      _comments.add(
        Comment(username: "You", text: text, timestamp: DateTime.now()),
      );
    });

    _commentController.clear();
    setState(() {
      _isComposing = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Add a method to parse text for emote codes
  List<dynamic> _parseTextForEmotes(String text) {
    final List<dynamic> result = [];
    final RegExp emoteRegex = RegExp(r':([a-zA-Z0-9]+):');
    int lastIndex = 0;
    
    for (final Match match in emoteRegex.allMatches(text)) {
      final String emoteName = match.group(1)!;
      final int startIndex = match.start;
      final int endIndex = match.end;
      
      // Add text before the emote
      if (startIndex > lastIndex) {
        result.add(text.substring(lastIndex, startIndex));
      }
      
      // Find the emote by name
      final Emote? emote = _availableEmotes.firstWhere(
        (e) => e.name == emoteName,
        orElse: () => Emote(name: "", url: ""),
      );
      
      // Add the emote or the original text if emote not found
      if (emote != null && emote.name.isNotEmpty) {
        result.add(emote);
      } else {
        result.add(text.substring(startIndex, endIndex));
      }
      
      lastIndex = endIndex;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      result.add(text.substring(lastIndex));
    }
    
    return result;
  }

  Widget _buildEmojiGrid(List<String> emojis) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _insertEmoji(emojis[index]),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(emojis[index], style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }

  // Add a method to build the emote grid
  Widget _buildEmoteGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _availableEmotes.length,
      itemBuilder: (context, index) {
        final emote = _availableEmotes[index];
        return GestureDetector(
          onTap: () => _insertEmoteCode(emote.name),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  emote.url,
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 32);
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  emote.name,
                  style: const TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add a method to render parsed content with emotes
  Widget _buildParsedContent(List<dynamic> parsedContent) {
    return Wrap(
      children: parsedContent.map((content) {
        if (content is String) {
          return Text(content);
        } else if (content is Emote) {
          return Image.network(
            content.url,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Text(':${content.name}:');
            },
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  final parsedContent = _parseTextForEmotes(comment.text);
                  
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
                              _buildParsedContent(parsedContent),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  bottom: !_showEmojiPicker,
                  child: Row(
                    children: [
                      // Emoji toggle button
                      IconButton(
                        icon: Icon(
                          _showEmojiPicker
                              ? Icons.keyboard
                              : Icons.emoji_emotions_outlined,
                        ),
                        onPressed: _toggleEmojiPicker,
                        color:
                            _showEmojiPicker
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                      ),
      
                      // Text input field
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          focusNode: _focusNode,
                          onChanged: (text) {
                            setState(() {
                              _isComposing = text.trim().isNotEmpty;
                            });
                          },
                          onSubmitted: (text) {
                            if (_isComposing) {
                              _handleNewComment(text);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            suffixIcon:
                                _isComposing
                                    ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _commentController.clear();
                                        setState(() {
                                          _isComposing = false;
                                        });
                                      },
                                    )
                                    : null,
                          ),
                        ),
                      ),
      
                      const SizedBox(width: 8),
      
                      // Send button
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _isComposing 
                            ? () => _handleNewComment(_commentController.text) 
                            : null,
                        color:
                            _isComposing
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
      
              // Emoji picker section with tabs
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _showEmojiPicker ? 250 : 0,
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
                child:
                    _showEmojiPicker
                        ? Column(
                          children: [
                            // Tab bar for emoji categories
                            TabBar(
                              controller: _tabController,
                              indicatorColor: Theme.of(context).primaryColor,
                              tabs: const [
                                Tab(
                                  icon: Icon(Icons.emoji_emotions),
                                  text: "Smileys",
                                ),
                                Tab(icon: Icon(Icons.pets), text: "Animals"),
                                Tab(icon: Icon(Icons.gif_box), text: "Emotes"),
                              ],
                            ),
      
                            // Tab bar view with emoji grids
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildEmojiGrid(smileyEmojis),
                                  _buildEmojiGrid(animalEmojis),
                                  _buildEmoteGrid(),
                                ],
                              ),
                            ),
                          ],
                        )
                        : null,
              ),
            ],
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
