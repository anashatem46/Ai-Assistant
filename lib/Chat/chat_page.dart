import 'dart:developer';
import 'dart:io';
import 'package:ai_assis/Chat/api_config.dart';
import 'package:ai_assis/Chat/mic_test.dart';
import 'package:ai_assis/constants.dart';
import 'package:ai_assis/models/message.dart';
import 'package:ai_assis/providers/chat_provider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isTyping = false;

  ChatUser currentUser = ChatUser(firstName: 'User', id: '0');
  ChatUser brainBox = ChatUser(
    firstName: 'BrainBox',
    id: '1',
    profileImage: "assets/images/ChatLogo.png",
  );

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
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          List<Message> messages = chatProvider.inChatMessages.reversed.toList();

          return Column(
            children: [
              Expanded(
                child: DashChat(
                  messages: messages.map((message) {
                    return ChatMessage(
                      text: message.message.toString(),
                      user: message.role == Role.user ? currentUser : brainBox,
                      createdAt: message.timeSent,
                    );
                  }).toList(),
                  onSend: (chatMessage) {
                    _sendMessage(chatProvider, chatMessage);
                  },
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
          );
        },
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider, ChatMessage chatMessage) {
    final userMessage = Message(
      messageId: const Uuid().v4(),
      chatId: chatProvider.getChatId(),
      role: Role.user,
      message: StringBuffer(chatMessage.text),
      imagesUrls: [],
      timeSent: DateTime.now(),
    );

    chatProvider.fetchAssistantResponse(userMessage.message.toString());
  }

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
      final chatProvider = context.read<ChatProvider>();
      final userMessage = Message(
        messageId: const Uuid().v4(),
        chatId: chatProvider.getChatId(),
        role: Role.user,
        message: StringBuffer("Sending PDF: ${result.files.single.name}"),
        imagesUrls: [],
        timeSent: DateTime.now(),
      );

      setState(() {
        chatProvider.inChatMessages.insert(0, userMessage);
      });

      try {
        final apiClient = ApiClient();
        apiClient.getAnswer('Summarize the pdf', file: file).then((response) {
          if (response.containsKey('response')) {
            String answerText = response['response'];
            setState(() {
              chatProvider.inChatMessages.insert(
                0,
                Message(
                  messageId: const Uuid().v4(),
                  chatId: chatProvider.getChatId(),
                  role: Role.assistant,
                  message: StringBuffer(answerText),
                  imagesUrls: [],
                  timeSent: DateTime.now(),
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SpeechScreen(
        onRecognized: (text) {
          final chatProvider = context.read<ChatProvider>();
          final userMessage = Message(
            messageId: const Uuid().v4(),
            chatId: chatProvider.getChatId(),
            role: Role.user,
            message: StringBuffer(text),
            imagesUrls: [],
            timeSent: DateTime.now(),
          );
          _sendMessage(chatProvider, ChatMessage(
            text: userMessage.message.toString(),
            user: currentUser,
            createdAt: DateTime.now(),
          ));
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
