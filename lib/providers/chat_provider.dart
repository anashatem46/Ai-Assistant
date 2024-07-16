import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:ai_assis/Chat/api_config.dart';
import 'package:ai_assis/constants.dart';
import 'package:ai_assis/hive/boxes.dart';
import 'package:ai_assis/hive/chat_history.dart';
import 'package:ai_assis/hive/settings.dart';
import 'package:ai_assis/hive/user_model.dart';
import 'package:ai_assis/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _inChatMessages = [];
  final PageController _pageController = PageController();
  List<XFile>? _imagesFileList;
  int _currentIndex = 0;
  String _currentChatId = '';
  bool _isLoading = false;
  final ApiClient _apiClient = ApiClient();

  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  bool get isLoading => _isLoading;

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    _inChatMessages.clear();
    _inChatMessages.addAll(messagesFromDB);
    notifyListeners();
  }

  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    final messageBox = await Hive.openBox<Map>('${Constants.chatMessagesBox}$chatId');
    final newData = messageBox.values.map((e) {
      final messageData = Message.fromMap(Map<String, dynamic>.from(e));
      return messageData;
    }).toList();
    await messageBox.close();
    return newData;
  }

  Future<void> deleteChatMessages({required String chatId}) async {
    final messageBox = await Hive.openBox<Map>('${Constants.chatMessagesBox}$chatId');
    await messageBox.clear();
    await messageBox.close();

    if (_currentChatId == chatId) {
      setCurrentChatId(newChatId: '');
      _inChatMessages.clear();
    }
    notifyListeners();
  }

  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    setCurrentChatId(newChatId: chatID);
    if (!isNewChat) {
      await setInChatMessages(chatId: chatID);
    } else {
      _inChatMessages.clear();
    }
  }

  Future<void> saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
  }) async {
    final messageBox = await Hive.openBox<Map>('${Constants.chatMessagesBox}$chatID');
    await messageBox.add(userMessage.toMap());
    await messageBox.add(assistantMessage.toMap());
    await messageBox.close();

    final chatHistoryBox = Boxes.getChatHistory();
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatID, chatHistory);
  }

  List<String> getImagesUrls() {
    List<String> imagesUrls = [];
    if (_imagesFileList != null) {
      for (var image in _imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  String getChatId() {
    if (_currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return _currentChatId;
    }
  }

  Future<void> fetchAssistantResponse(dynamic userInput) async {
    setLoading(value: true);
    try {
      String userMessage = userInput is String ? userInput : '';

      if (userInput is Map<String, dynamic>) {
        userMessage = userInput['message'] ?? '';
      }

      final response = await _apiClient.getAnswer(userMessage);
      final chatId = getChatId();
      final responseMap = response is Map<String, dynamic> ? response : {'response': response};

      final assistantMessage = Message(
        messageId: const Uuid().v4(),
        chatId: chatId,
        role: Role.assistant,
        message: StringBuffer(responseMap['response'] ?? ''),
        imagesUrls: [],
        timeSent: DateTime.now(),
      );

      await saveMessagesToDB(
        chatID: chatId,
        userMessage: Message(
          messageId: const Uuid().v4(),
          chatId: chatId,
          role: Role.user,
          message: StringBuffer(userMessage),
          imagesUrls: [],
          timeSent: DateTime.now(),
        ),
        assistantMessage: assistantMessage,
      );

      await setInChatMessages(chatId: chatId);
    } catch (e) {
      log('Error fetching assistant response: $e');
    }
    setLoading(value: false);
  }

  static Future<void> initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(ChatHistoryAdapter().typeId)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }

    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }

    if (!Hive.isAdapterRegistered(SettingsAdapter().typeId)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }
  }
}
