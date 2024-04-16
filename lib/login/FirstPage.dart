import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assis/login/loginPage.dart';
import 'package:ai_assis/login/signUp.dart';


class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  void onPressed() {
    print('Button Pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: 60,
              ),
              width: 350,
              height: 350,
              child: Image.asset(
                'assets/images/Logo_2.png',
                width: 500,
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
              onPressed: (){
                print('Button Pressed');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginPage()));

              },
              child: Container(
                width: 342,
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
            MaterialButton(
              onPressed: () {
                print('Button pressed!'); // Add this line
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => signUp()));
              },
              child:
              Container(







                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                alignment: Alignment.center,
                margin:  EdgeInsets.only(
                  top: 20,
                ),
                child:
              const Text('Sign Up',style: TextStyle(
              color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.06,
              ),),
            ),
            ),
          ],
        )),
        ),
        );

  }
}
