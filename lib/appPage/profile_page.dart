import 'package:ai_assis/auth/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildHProfile(BuildContext context) {
  return Scaffold(
    body: Center(
      child: IconButton(
        onPressed: () async {
          final savedContext = context; // Save the context before the async call
          await FirebaseAuth.instance.signOut();
          if (savedContext.mounted) {
            Navigator.of(savedContext).pushReplacement(
                MaterialPageRoute(builder: (context) => const IntroPage()));
          }
        },
        icon: const Icon(Icons.exit_to_app),
      ),
    ),
  );
}
