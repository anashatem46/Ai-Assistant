import 'dart:developer';
import 'package:ai_assis/appPage/first_page.dart';
import 'package:ai_assis/auth/login_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

///TODO USE LOWERCASE FOR FILE NAME
///TODO USE CAMELCASE FOR CLASS NAME
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _MyAppState();
}

class _MyAppState extends State<SignUp> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();

  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Account',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(
                  top: 40.0, left: 40.0, right: 50), // Use double precision
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      hintText: 'Anas Hatem',
                      // Placeholder text
                      //isDense: true, // Compact text field for a cleaner look
                      contentPadding:
                          const EdgeInsets.all(8.0), // Adjust content padding
                    ),
                    keyboardType: TextInputType
                        .emailAddress, // Set keyboard type for email input
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(
                  top: 20.0, left: 40.0, right: 50), // Use double precision
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
                      fontWeight: FontWeight.w600,
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
                    keyboardType: TextInputType
                        .emailAddress, // Set keyboard type for email input
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
              ),
              // Use double precision
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
                      fontWeight: FontWeight.w600,
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
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: MaterialButton(
                onPressed: () async {
                  log('Button Pressed');
                  // Save the context before the async call
                  final savedContext = context;
                  try {
                    ///TODO: IF YOU WILL NOT USE THE CREDENTIAL VAR CLEAR IT
                    // final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailAddress.text,
                      password: password.text,
                    );
                    if (savedContext.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (savedContext.mounted) {
                      if (e.code == 'weak-password') {
                        log('The password provided is too weak.');
                        AwesomeDialog(
                          context: savedContext,
                          animType: AnimType.scale,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'The password provided is too weak.',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        log('The account already exists for that email.');
                        AwesomeDialog(
                          context: savedContext,
                          animType: AnimType.scale,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'The account already exists for that email.',
                        ).show();
                      }
                    }
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: Container(
                  width: 200,
                  height: 56,
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
                          'Sign Up',
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
            ),
            SignInButton(
              Buttons.google,
              onPressed: () {},
            ),
            SignInButton(
              Buttons.facebook,
              onPressed: () {},
            ),
            SignInButton(
              Buttons.apple,
              onPressed: () {},
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
                          builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      'Login',
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
    );
  }
}
