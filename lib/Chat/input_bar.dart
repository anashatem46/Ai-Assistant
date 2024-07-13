import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class CustomInputBar extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onPickFile;
  final VoidCallback onMic;

  CustomInputBar({
    required this.textController,
    required this.onSend,
    required this.onPickImage,
    required this.onPickFile,
    required this.onMic,
  });

  @override
  _CustomInputBarState createState() => _CustomInputBarState();
}

class _CustomInputBarState extends State<CustomInputBar> {
  FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isTyping = _focusNode.hasFocus && widget.textController.text.isNotEmpty;
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
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
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
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                // Handle camera action
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: widget.onPickImage,
            ),
            IconButton(
              icon: Icon(Icons.folder),
              onPressed: widget.onPickFile,
            ),
          ],
          Expanded(
            child: TextField(
              controller: widget.textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Message",
                border: InputBorder.none,
              ),
            ),
          ),
          if (!_isTyping)
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: widget.onMic,
            ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: widget.onSend,
          ),
        ],
      ),
    );
  }
}
