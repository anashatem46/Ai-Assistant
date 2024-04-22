
import 'package:flutter/material.dart';
import 'package:ai_assis/Onboboarding/onboarding_view.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ai_assis/Chat/consts.dart';





void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        ),


      home:  OnboardingView(),
    );
  }
}
