import 'package:flutter/material.dart';
import 'package:ai_assis/hive/boxes.dart';
import 'package:ai_assis/hive/chat_history.dart';
import 'package:ai_assis/widegts/chat_history_widget.dart';
import 'package:ai_assis/widegts/empty_history_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        centerTitle: true,
        //automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder<Box<ChatHistory>>(
        valueListenable: Boxes.getChatHistory().listenable(),
        builder: (context, box, _) {
          final chatHistory = box.values.toList().cast<ChatHistory>();
          // Sort the chat history by timestamp in descending order (most recent first)
          chatHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return chatHistory.isEmpty
              ? const EmptyHistoryWidget()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final chat = chatHistory[index];
                      return ChatHistoryWidget(chat: chat);
                    },
                  ),
                );
        },
      ),
    );
  }
}
