import 'dart:developer';
import 'package:ai_assis/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:ai_assis/auth/sign_up.dart';

///TODO USE LOWERCASE FOR FILE NAME
///TODO USE CAMELCASE FOR CLASS NAME
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  void onPressed() {
    ///TODO USE LOG INSTEAD OF PRINT FOR DEBUG DATA
    log('Button Pressed');
    // print('Button Pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                'assets/images/LogoLight.png',
                width: 500,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            child: const Text(
              ' Welcome to \n BrainBox',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 80,
            ),
            child: const Text(
              'We re excited to help you with best \n experience you could have with AI ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              log('Button Pressed');
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Container(
              width: 342,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0.06,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              log('Button pressed!'); // Add this line
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0.06,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
