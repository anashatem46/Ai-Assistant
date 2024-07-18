import 'dart:developer';
import 'package:ai_assis/auth/sign_up.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../app_page/first_page.dart';

///TODO USE LOWERCASE FOR FILE NAME
///TODO USE CAMELCASE FOR CLASS NAME
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyAppState();
}

class _MyAppState extends State<LoginPage> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(
                    top: 40.0, left: 40.0), // Use double precision
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 2.0,
                      ),
                    ),
                    Text(
                      'Welcome back to the app',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(
                    top: 40.0, left: 40.0, right: 50), // Use double precision
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextFormField(
                      controller: emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'hello@example.com',
                        // Placeholder text
                        //isDense: true, // Compact text field for a cleaner look
                        contentPadding:
                            const EdgeInsets.all(8.0), // Adjust content padding
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                    right: 50,
                    bottom: 50), // Use double precision
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _showPassword,
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  // Save the context before the async call
                  final savedContext = context;

                  try {
                    ///TODO: IF YOU WILL NOT USE THE CREDENTIAL VAR CLEAR IT
                    // final credential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailAddress.text, password: password.text);
                    ///info: Don't use 'BuildContext's across async gaps.
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) => const HomePage()));
                    /// USE IT LIKE THAT.
                    if (savedContext.mounted) {
                      Navigator.of(savedContext).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomePage()));
                    }

                  } on FirebaseAuthException catch (e) {
                    if (savedContext.mounted) {
                      if (e.code == 'user-not-found') {
                        log('No user found for that email.');
                        AwesomeDialog(
                          context: savedContext,
                          animType: AnimType.scale,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'No user found for that email.',
                        ).show();
                      } else if (e.code == 'wrong-password') {
                        log('Wrong password provided for that user.');
                        AwesomeDialog(
                          context: savedContext,
                          animType: AnimType.scale,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'Password or Email Wrong',
                        ).show();
                      }
                    }
                  }
                },
                child: Container(
                  width: 200,
                  height: 56,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.of(context).pushReplacement(MaterialPageRoute(
              //         builder: (context) => const HomePage()));
              //   },
              //   child: Container(
              //     width: 200,
              //     height: 56,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              //     decoration: ShapeDecoration(
              //       color: Colors.black,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(32),
              //       ),
              //     ),
              //     child: const Row(
              //       mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         SizedBox(
              //           width: 160,
              //           child: Text(
              //             'Login',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //               fontFamily: 'Inter',
              //               fontWeight: FontWeight.w500,
              //               height: 0.06,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                      Buttons.facebook,
                      mini: true,
                      onPressed: () {},
                    ),SignInButton(
                      Buttons.linkedIn,
                      mini: true,
                      onPressed: () {},
                    ),SignInButton(
                      Buttons.appleDark,
                      mini: true,
                      onPressed: () {},
                    )



                ],),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Color(0xFF999DA3),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0.09,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        log('Button pressed!');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUp()));
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
