import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../hive/chat_history.dart';
import '../Chat/chat_page.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({
    super.key,
    required this.chat,
  });

  final ChatHistory chat;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chat.chatId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteChat(context, chat);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        color: Colors.white,
        child: ListTile(
          onTap: () => _navigateToChat(context, chat.chatId),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 30,
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
          title: Text(
            chat.prompt,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const SizedBox.shrink(),
          onLongPress: () => _deleteChat(context, chat),
        ),
      ),
    );
  }

  Future<void> _navigateToChat(BuildContext context, String chatId) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    BuildContext buildContext = context;

    await chatProvider.prepareChatRoom(
      isNewChat: false,
      chatID: chatId,
    );
    chatProvider.setCurrentIndex(newIndex: 1);

    if (buildContext.mounted) {
      Navigator.push(
        buildContext,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    }
  }

  Future<void> _deleteChat(BuildContext context, ChatHistory chat) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    log('Deleting chat with ID: ${chat.chatId}'); // Debug statement
    await chatProvider.deleteChatMessages(chatId: chat.chatId);
    await chat.delete();
  }
}
