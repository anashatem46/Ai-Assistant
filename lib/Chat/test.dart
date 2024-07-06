// mic chat page
// Compare this snippet from lib/Chat/Chatpage.dart:

import 'package:flutter/material.dart';

class MicPage extends StatefulWidget {
  const MicPage({super.key});

  @override
  State<MicPage> createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Mic Page'),
      ),
      body: const Center(
        child: Text('Mic '),

      ),
    );
  }
}
