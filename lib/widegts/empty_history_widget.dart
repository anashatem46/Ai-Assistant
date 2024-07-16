import 'package:ai_assis/hive/boxes.dart';
import 'package:ai_assis/hive/chat_history.dart';
import 'package:ai_assis/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // Create a new chat ID
          final newChatId = const Uuid().v4();

          // Add new chat to chat history
          final chatHistoryBox = Boxes.getChatHistory();
          final newChat = ChatHistory(
            chatId: newChatId,
            prompt: 'New Chat', // Customize prompt as needed
            response: '', // Set initial response if needed
            imagesUrls: [], // Initialize images URLs if needed
            timestamp: DateTime.now(),
          );
          await chatHistoryBox.put(newChatId, newChat);

          // Navigate to chat screen
          final chatProvider = context.read<ChatProvider>();
          // Prepare chat room
          await chatProvider.prepareChatRoom(
            isNewChat: true,
            chatID: newChatId,
          );
          chatProvider.setCurrentIndex(newIndex: 1);
          Future.delayed(Duration(milliseconds: 100), () {
            chatProvider.pageController.jumpToPage(1);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No chat found, start a new chat!',
            ),
          ),
        ),
      ),
    );
  }
}
