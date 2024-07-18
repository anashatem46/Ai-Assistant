import 'dart:developer';
import 'package:ai_assis/Chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../hive/chat_history.dart';
import '../providers/chat_provider.dart';

Widget buildHomePage(BuildContext context) {
  return Center(
    child: Stack(
      children: [
        Align(
            alignment: Alignment.center, // Center the column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/LogoLight.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Rich text title centered within available space
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to \n',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 40,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'BrainBox',
                          style: TextStyle(
                            color: Color(0xFF141718),
                            fontSize: 40,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Start chatting with ChatAI now.\nYou can ask me anything.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF616161),
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    log('Button Pressed');
                    _startNewChat(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    width: 200,
                    height: 56,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0.06,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}

Future<void> _startNewChat(BuildContext context) async {
  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  final newChatId = const Uuid().v4();
  BuildContext buildContext = context;

  await chatProvider.prepareChatRoom(
    isNewChat: true,
    chatID: newChatId,
  );
  chatProvider.setCurrentIndex(newIndex: 1);

  final chatHistoryBox = Hive.box<ChatHistory>('chat_history');
  final newChat = ChatHistory(
    chatId: newChatId,
    prompt: 'New Chat',
    // Customize prompt as needed
    response: '',
    // Set initial response if needed
    imagesUrls: [],
    // Initialize images URLs if needed
    timestamp: DateTime.now(),
  );
  await chatHistoryBox.put(newChatId, newChat);
  if (buildContext.mounted) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }
}
