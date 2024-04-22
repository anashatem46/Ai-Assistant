import 'dart:developer';


import 'package:ai_assis/Components/custom_app_bar.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(firstName: 'User', id: '0');
  ChatUser geminiUser = ChatUser(firstName: 'Gemini', id: '1');

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
                'Gemini',
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
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: SizedBox(
      //
      //         child: ListView.builder(
      //           itemCount: 10,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               title: Text('Message $index'),
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      //       child: TextField(
      //
      //         decoration: InputDecoration(
      //       focusedBorder: const OutlineInputBorder(
      //             borderSide: BorderSide(color: Colors.grey, width: 0.0),
      //           ),
      //           enabledBorder: const OutlineInputBorder(
      //             borderSide: BorderSide(color: Colors.grey, width: 0.0),
      //           ),
      //           fillColor:Colors.white,
      //           border: OutlineInputBorder(
      //
      //
      //             borderRadius: BorderRadius.circular(7.0),
      //             borderSide: const BorderSide(color: Colors.grey),
      //           ),
      //           contentPadding: const EdgeInsets.all(8.0),
      //           suffixIcon: IconButton(
      //             icon: const Icon(
      //               Icons.send_rounded,
      //               color: Colors.grey,
      //             ),
      //             onPressed: () {
      //
      //               log('Button Pressed');
      //             },
      //           ),
      //         ),
      //         obscureText: false,
      //       ),
      //     ),
      //   ],
      // )
      body: _buildui(),
    );
  }

  Widget _buildui() {
    return Column(
      children: [
        Expanded(
          child: DashChat(
            messages: messages,
            onSend: _sendMessage,
            currentUser: currentUser,
          ),
        ),
      ],
    );
  }


  void _sendMessage(ChatMessage chatMessage) {
    log("message");
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      gemini
          .streamGenerateContent(
        question,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
                () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

}
