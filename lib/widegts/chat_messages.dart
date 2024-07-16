import 'package:ai_assis/models/message.dart';
import 'package:ai_assis/providers/chat_provider.dart';
import 'package:ai_assis/widegts/assistance_message_widget.dart';
import 'package:ai_assis/widegts/my_message_widget.dart';
import 'package:flutter/material.dart';


class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.scrollController,
    required this.chatProvider,
  });

  final ScrollController scrollController;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inChatMessages.length,
      itemBuilder: (context, index) {
        // compare with timeSent bewfore showing the list
        final message = chatProvider.inChatMessages[index];
        return message.role.name == Role.user.name
            ? MyMessageWidget(message: message)
            : AssistantMessageWidget(message: message.message.toString());
      },
    );
  }
}
