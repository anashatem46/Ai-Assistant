import 'package:ai_assis/auth/IntroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildHProfile(BuildContext context) {
  return Scaffold(
      body: Center(
    child: IconButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Intropage()));
      },
      icon: Icon(Icons.exit_to_app),
    ),
  ));
}
