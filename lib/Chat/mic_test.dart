import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
class SpeechScreen extends StatefulWidget {
  final Function(String) onRecognized;

  const SpeechScreen({super.key, required this.onRecognized});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  @override
  void dispose() {
    _speech.stop(); // Ensure speech recognition is stopped
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(); // Close the screen
          },
        ),
        title: const Text('Speak to BrainBox'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        backgroundColor: _isListening ? Colors.red : Colors.black,
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_off,
          color: _isListening ? Colors.white : Colors.white,
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          log('onStatus: $val');
          if (mounted) {
            setState(() => _isListening = val == 'listening');
          }
        },
        onError: (val) {
          log('onError: $val');
          if (mounted) {
            setState(() => _isListening = false);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${val.errorMsg}')),
          );
        },
      );
      if (available) {
        if (mounted) {
          setState(() => _isListening = true);
        }
        _speech.listen(
  onResult: (val) {
    if (mounted) {
      setState(() {
        _text = val.recognizedWords;
        _recognizedText = val.recognizedWords; // Store the recognized text in the variable
        log('Recognized Text: $_recognizedText');
      });
      widget.onRecognized(_recognizedText); // Invoke the callback with the recognized text
    }
  },
  localeId: 'en_US', // Set the locale for English (US)
);
      } else {
        if (mounted) {
          setState(() => _isListening = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    } else {
      if (mounted) {
        setState(() => _isListening = false);
      }
      _speech.stop();
    }
  }
}
