import 'dart:developer';
import 'dart:io';
import 'package:ai_assis/Chat/api_config.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'mic_test.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  List<ChatMessage> messages = [];
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isTyping = false;

  ChatUser currentUser = ChatUser(firstName: 'User', id: '0');
  ChatUser brainBox = ChatUser(
      firstName: 'BrainBox',
      id: '1',
      profileImage: "assets/images/ChatLogo.png");

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isTyping = focusNode.hasFocus && textController.text.isNotEmpty;
      });
    });
    textController.addListener(() {
      setState(() {
        isTyping = textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat with BrainBox'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              messages: messages,
              onSend: _sendMessage,
              currentUser: currentUser,
              inputOptions: InputOptions(
                textController: textController,
                focusNode: focusNode,
                inputDecoration: InputDecoration(
                  hintText: "Write a message...",
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                trailing: [
                  if (!isTyping) ...[
                    // IconButton(
                    //   icon: Icon(Icons.camera_alt),
                    //   onPressed: () {
                    //     // Handle camera action
                    //   },
                    // ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _handlePickImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.folder),
                      onPressed: _handlePickFile,
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: _handleMic,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
///TODO CLEAN THE CODE FORM THE UNUSED FUNCTIONS
  /*
  void _handleSend() {
    if (textController.text.isNotEmpty) {
      ChatMessage message = ChatMessage(
        text: textController.text,
        user: currentUser,
        createdAt: DateTime.now(),
      );
      _sendMessage(message);
      textController.clear();
    }
  }
*/

  void _handlePickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle image pick
    }
  }

  void _handlePickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
    text: "Sending PDF: ${result.files.single.name}",

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





  void _handleMic() {
    Navigator.of(context).push(_createRoute());
  }

  void _sendMessage(ChatMessage chatMessage) {
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
