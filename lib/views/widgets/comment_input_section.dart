import 'package:flutter/material.dart';
import 'package:livelite_client/views/misc/emojis.dart';

class CommentInputSection extends StatefulWidget {
  final Function(String) onCommentSubmitted;

  const CommentInputSection({super.key, required this.onCommentSubmitted});

  @override
  State<CommentInputSection> createState() => _CommentInputSectionState();
}

class _CommentInputSectionState extends State<CommentInputSection>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  bool _isComposing = false;
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;

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

  void _handleSubmitted() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      widget.onCommentSubmitted(text);
      _commentController.clear();
      setState(() {
        _isComposing = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    onSubmitted:
                        (_) => _isComposing ? _handleSubmitted() : null,
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
                  onPressed: _isComposing ? _handleSubmitted : null,
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
                          Tab(icon: Icon(Icons.fastfood), text: "Food"),
                        ],
                      ),

                      // Tab bar view with emoji grids
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildEmojiGrid(smileyEmojis),
                            _buildEmojiGrid(animalEmojis),
                            _buildEmojiGrid(foodEmojis),
                          ],
                        ),
                      ),
                    ],
                  )
                  : null,
        ),
      ],
    );
  }
}
// 