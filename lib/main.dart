import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void onPressed() {
    print('Button Pressed');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Container(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top:60,),
              width: 350,
              height: 350,
              child: Image.asset(
                'assets/images/App_logo.png',
                width: 500,
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom:20,),
              child: const Text(
                'Welcome to our \n Ai assistant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2F4EFF),
                  fontSize: 40,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom:80,),
              child: const Text(
                'We re excited to help you with best \n experience you could have with AI ',

                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5868A1),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),

           MaterialButton(onPressed: onPressed , child: Container(
             width: 342,
             height: 56,
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
             decoration: ShapeDecoration(
               color: Color(0xFF2F4EFF),
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
           MaterialButton(onPressed: onPressed , child: Text('Sign Up'),),
          ],
        )),
      ),
    );
  }
}


