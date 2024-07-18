import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissionsAndInitialize();
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
            _text = result.recognizedWords;
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              widget.onRecognized(result.recognizedWords);
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
      floatingActionButton: FloatingActionButton(
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
              _text,
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
