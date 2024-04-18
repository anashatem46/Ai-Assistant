
import 'package:flutter/material.dart';
import 'package:ai_assis/Onboboarding/onboarding_view.dart';






void main() {
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
