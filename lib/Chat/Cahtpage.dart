import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_assis/Chat/apiConfig.dart';
import 'package:ai_assis/Chat/mic_page.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'mic_test.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(firstName: 'User', id: '0');
  ChatUser brainBox = ChatUser(
      firstName: 'BrainBox',
      id: '1',
      profileImage: "assets/images/LogoLight.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat with BrainBox'),
        centerTitle: true,
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Column(
      children: [
        Expanded(
          child: DashChat(
            inputOptions: InputOptions(trailing: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: _sendPdf,
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
              )
            ]),
            messages: messages,
            onSend: _sendMessage,
            currentUser: currentUser,
          ),
        ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    if (chatMessage.text.isNotEmpty) {
      log("Sending message: ${chatMessage.text}");
      setState(() {
        messages = [chatMessage, ...messages];
      });
      try {
        final String question = chatMessage.text;
        log("Sending message: $question");

        final apiClient = ApiClient();
        apiClient.getAnswer(question).then((response) {
          if (response.containsKey('response')) {
            String answerText = response['response'];
            setState(() {
              messages.insert(
                0,
                ChatMessage(
                  text: answerText,
                  user: brainBox,
                  createdAt: DateTime.now(),
                ),
              );
            });
          }
        }).catchError((error) {
          log(error.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
            ),
          );
        });
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    } else {
      log("No text to send");
    }
  }

  void _sendPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Sending PDF...",
      );

      // Update message list immediately
      setState(() {
        messages = [chatMessage, ...messages];
      });

      // Send the PDF
      try {
        final apiClient = ApiClient();
        apiClient.getAnswer('Summarize the pdf', file: file).then((response) {
          if (response.containsKey('response')) {
            String answerText = response['response'];
            setState(() {
              messages.insert(
                0,
                ChatMessage(
                  text: answerText,
                  user: brainBox,
                  createdAt: DateTime.now(),
                ),
              );
            });
          }
        }).catchError((error) {
          log(error.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
            ),
          );
        });
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SpeechScreen(
        onRecognized: (text) {
          ChatMessage chatMessage = ChatMessage(
            text: text,
            user: currentUser,
            createdAt: DateTime.now(),
          );
          _sendMessage(chatMessage);
        },
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
