// lib/widgets/bottom_chat_field.dart

import 'package:flutter/material.dart';
import 'package:ai_assis/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';

class BottomChatField extends StatefulWidget {
  final ChatProvider chatProvider;

  const BottomChatField({required this.chatProvider, Key? key}) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile>? images = await picker.pickMultiImage();
              if (images != null) {
                widget.chatProvider.setImagesFileList(listValue: images);
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (value) {
                // Handle message send
                // Example: widget.chatProvider.sendMessage(value);
                _controller.clear();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Handle send button press
              // Example: widget.chatProvider.sendMessage(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
