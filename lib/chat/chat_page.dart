import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:ai_assis/Chat/api_config.dart';
import 'package:ai_assis/Chat/mic_test.dart';
import 'package:ai_assis/models/message.dart';
import 'package:ai_assis/providers/chat_provider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textController = TextEditingController();

  FocusNode focusNode = FocusNode();

  bool isTyping = false;
  bool isLoading = false;

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
          List<Message> messages = chatProvider.inChatMessages;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isLoading && index == 0) {
                      return _buildLoadingIndicator();
                    }
                    final message = messages[index - (isLoading ? 1 : 0)];
                    return _buildMessage(message);
                  },
                ),
              ),
              _buildInputArea(chatProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12,12,12,20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Write a message...",
                fillColor: Colors.grey[200],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (text) {
                setState(() {
                  isTyping = text.isNotEmpty;
                });
              },
            ),
          ),
          if (isTyping) ...[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (textController.text.isNotEmpty) {
                final chatMessage = ChatMessage(
                  text: textController.text,
                  user: currentUser,
                  createdAt: DateTime.now(),
                );
                _sendMessage(chatProvider, chatMessage);
                textController.clear();
                setState(() {
                  isTyping = false;
                });
              }
            },
          ),],
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
    );
  }

  Widget _buildMessage(Message message) {
    final isUserMessage = message.role == Role.user;
    final bubbleAlignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isUserMessage ? Colors.blue[100] : Colors.grey[200];
    final bubbleRadius = isUserMessage
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUserMessage) ...[
            CircleAvatar(
              backgroundImage: AssetImage(brainBox.profileImage ?? ''),
              radius: 15,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: bubbleAlignment,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: bubbleRadius,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: message.isImage
                      ? Image.memory(
                          base64Decode(message.imagesUrls[0]),
                          // Decode base64 string to Uint8List
                          fit: BoxFit.cover,
                        )
                      : Text(message.message.toString()),
                ),
              ],
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 10),
            const CircleAvatar(
              backgroundImage: AssetImage( 'assets/images/Rectangle1.png'),
              radius: 15,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(brainBox.profileImage ?? ''),
            radius: 15,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("..."),
                      SizedBox(width: 5),
                      CircularProgressIndicator(strokeWidth: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
      isImage: false,
    );
    setState(() {
      isLoading = true;
    });
    chatProvider
        .fetchAssistantResponse(userMessage.message.toString())
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handlePickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle image pick
    }
  }

  void _handlePickFile() async {
    final chatProvider = context.read<ChatProvider>();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      final userMessage = Message(
        messageId: const Uuid().v4(),
        chatId: chatProvider.getChatId(),
        role: Role.user,
        message: StringBuffer("Sending PDF: ${result.files.single.name}"),
        imagesUrls: [],
        timeSent: DateTime.now(),
        isImage: false,
      );

      setState(() {
        chatProvider.inChatMessages.insert(0, userMessage);
        isLoading = true;
      });

      try {
        final apiClient = ApiClient();
        final response = await apiClient.getAnswer('Summarize the pdf', file: file);

        if (mounted) {
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
                  isImage: false,
                ),
              );
              isLoading = false;
            });
          }
        }
      } catch (error) {
        log(error.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
            ),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void _handleMic() {
    Navigator.of(context).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SpeechScreen(
        onRecognized: (text) async {
          final chatProvider = context.read<ChatProvider>();
          final userMessage = Message(
            messageId: const Uuid().v4(),
            chatId: chatProvider.getChatId(),
            role: Role.user,
            message: StringBuffer(text),
            imagesUrls: [],
            timeSent: DateTime.now(),
            isImage: false,
          );

          if (mounted) {
            _sendMessage(
              chatProvider,
              ChatMessage(
                text: userMessage.message.toString(),
                user: currentUser,
                createdAt: DateTime.now(),
              ),
            );
          }
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
