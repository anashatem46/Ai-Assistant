import 'package:ai_assis/appPage/preferencespage.dart';
import 'package:ai_assis/auth/IntroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

@override
Widget buildToolsPage(BuildContext context) {
  return Scaffold(
    appBar:  AppBar(
      title: const Text('Tools'),
      centerTitle: true,
    ),
  );
}
