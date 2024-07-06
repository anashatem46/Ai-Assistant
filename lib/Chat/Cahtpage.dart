import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:ai_assis/Chat/apiConfig.dart';
import 'package:ai_assis/Chat/test.dart';
import 'package:ai_assis/custom_app_bar.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      appBar: CustomAppBar(
        appBarWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset:
                            const Offset(10, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(child: Icon(Icons.arrow_back_ios_new)),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'brainBox',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  log('Button Pressed');
                },
                child: const Center(
                  child: Icon(
                    Icons.more_horiz,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                icon: const Icon(Icons.image),
                onPressed: _sendMedia,
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
    log("Sending message: ${chatMessage.text}");
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
     List <Uint8List>? images ;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      final String question = chatMessage.text;
      log("Sending message2: $question");

      // Create an instance of ApiClient
      final apiClient = ApiClient();
      apiClient.getAnswer(question).then((answer) {
        setState(() {
          messages.insert(
            0,
            ChatMessage(
              text: answer,
              user: brainBox,
              createdAt: DateTime.now(),
            ),
          );
        });
      }).catchError((error) {
        log(error.toString());
        // Display error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
          ),
        );
      });
    } catch (e) {
      log(e.toString());
      // Display generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
  //send media function

  void _sendMedia() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        medias: [ChatMedia(url: image.path, fileName: "", type: MediaType.image)],
      );
      _sendMessage(chatMessage);
    }
  }


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MicPage(),
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


