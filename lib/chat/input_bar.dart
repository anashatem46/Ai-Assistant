import 'package:flutter/material.dart';

class CustomInputBar extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onPickFile;
  final VoidCallback onMic;

  const CustomInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    required this.onPickImage,
    required this.onPickFile,
    required this.onMic,
  });

  @override
  State<CustomInputBar> createState() => _CustomInputBarState();
}

class _CustomInputBarState extends State<CustomInputBar> {
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isTyping =
            _focusNode.hasFocus && widget.textController.text.isNotEmpty;
      });
    });
    widget.textController.addListener(() {
      setState(() {
        _isTyping = widget.textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_isTyping) ...[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // Handle camera action
              },
            ),
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: widget.onPickImage,
            ),
            IconButton(
              icon: const Icon(Icons.folder),
              onPressed: widget.onPickFile,
            ),
          ],
          Expanded(
            child: TextField(
              controller: widget.textController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
            ),
          ),
          if (!_isTyping)
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: widget.onMic,
            ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: widget.onSend,
          ),
        ],
      ),
    );
  }
}
