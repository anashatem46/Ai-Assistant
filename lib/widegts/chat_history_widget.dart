import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/chat_provider.dart';
import '../hive/chat_history.dart';
import '../Chat/chat_page.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({
    Key? key,
    required this.chat,
    this.isNewChat = false,
  }) : super(key: key);

  final ChatHistory chat;
  final bool isNewChat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.chat),
        ),
        title: Text(
          chat.prompt,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: const SizedBox.shrink(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isNewChat) // Only show 'Add' button if it's not a new chat
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startNewChat(context),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () => _navigateToChat(context, chat.chatId),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteChat(context, chat),
            ),
          ],
        ),
        onLongPress: () => _deleteChat(context, chat),
      ),
    );
  }

  Future<void> _navigateToChat(BuildContext context, String chatId) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.prepareChatRoom(
      isNewChat: false,
      chatID: chatId,
    );
    chatProvider.setCurrentIndex(newIndex: 1);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }

  Future<void> _startNewChat(BuildContext context) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final newChatId = const Uuid().v4();
    await chatProvider.prepareChatRoom(
      isNewChat: true,
      chatID: newChatId,
    );
    chatProvider.setCurrentIndex(newIndex: 1);

    final chatHistoryBox = Hive.box<ChatHistory>('chat_history');
    final newChat = ChatHistory(
      chatId: newChatId,
      prompt: 'New Chat', // Customize prompt as needed
      response: '', // Set initial response if needed
      imagesUrls: [], // Initialize images URLs if needed
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(newChatId, newChat);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }

    Future<void> _deleteChat(BuildContext context, ChatHistory chat) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    print('Deleting chat with ID: ${chat.chatId}'); // Debug statement
    await chatProvider.deleteChatMessages(chatId: chat.chatId);
    await chat.delete();
  }
}

