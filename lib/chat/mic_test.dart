import 'dart:developer';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../models/message.dart';
import '../providers/chat_provider.dart';

enum TtsState { playing, stopped, paused, continued }

class SpeechScreen extends StatefulWidget {
  final Function(String) onRecognized;

  const SpeechScreen({super.key, required this.onRecognized});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  ChatUser currentUser = ChatUser(firstName: 'User', id: '0');

  ////////////////////////////////////////////////////////////////////////////////
  /// PART RELATED TO TEXT TO SPEECH (TTS)

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  bool get isStopped => ttsState == TtsState.stopped;

  bool get isPaused => ttsState == TtsState.paused;

  bool get isContinued => ttsState == TtsState.continued;
  bool isResponseSpeech = false;

  void setVarSpeak(String value) {
    _newVoiceText = value;
  }

  Future<void> speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
      await flutterTts.speak(_newVoiceText!);
    }
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    setState(() {
      isResponseSpeech = false;
    });
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  dynamic initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    flutterTts.setStartHandler(() {
      setState(() {
        log("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        log("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        log("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        log("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        log("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        log("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  ////////////////////////////////////////////////////////////////////////////////
  /// PART RELATED TO TEXT TO SPEECH (TTS)

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissionsAndInitialize();
    initTts();
  }

  Future<void> _checkPermissionsAndInitialize() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      var result = await Permission.microphone.request();
      if (result.isDenied) {
        _showPermissionDeniedDialog();
        return;
      }
    }
    _initializeSpeechRecognizer();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Denied'),
        content: const Text('Please enable microphone permission in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeSpeechRecognizer() async {
    bool available = await _speech.initialize(
      onError: (val) => log('onError: $val'),
      onStatus: (val) => log('onStatus: $val'),
    );
    if (!available) {
      setState(() => _text = 'Speech recognition not available');
    }
  }

  @override
  void dispose() {
    _speech.stop();
    flutterTts.stop();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          log('onStatus: $val');
          setState(() => _isListening = val == 'listening');
        },
        onError: (val) {
          log('onError: $val');
          setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            setState(() {
              isResponseSpeech = false;
            });
            _text = result.recognizedWords;
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              final chatProvider = context.read<ChatProvider>();
              final chatMessage = ChatMessage(
                text: result.recognizedWords,
                user: currentUser,
                createdAt: DateTime.now(),
              );
              final userMessage = Message(
                messageId: const Uuid().v4(),
                chatId: chatProvider.getChatId(),
                role: Role.user,
                message: StringBuffer(chatMessage.text),
                imagesUrls: [],
                timeSent: DateTime.now(),
                isImage: false,
                isImageSingle: false,
                messageImage: '',
              );
              chatProvider
                  .fetchAssistantResponse(userMessage.message.toString())
                  .then((_) {
                setState(() {
                  _text = context.read<ChatProvider>().voiceResponse;
                  _newVoiceText = context.read<ChatProvider>().voiceResponse;
                  speak();
                  isResponseSpeech = true;
                });
              });
              _speech.stop();
              setState(() => _isListening = false);
            }
          }),
          pauseFor: const Duration(seconds: 5),
        );
      } else {
        setState(() {
          _isListening = false;
          _text = 'Speech recognition not available';
        });
      }
    } else {
      _speech.stop();
      setState(
        () {
          _isListening = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Speak to BrainBox'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isResponseSpeech
          ? FloatingActionButton(
              onPressed: _stop,
              backgroundColor: isResponseSpeech ? Colors.red : Colors.black,
              child: Icon(
                isResponseSpeech ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: _listen,
              backgroundColor: _isListening ? Colors.red : Colors.black,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              chatProvider.isLoading ? 'LOADING .....' : _text,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
