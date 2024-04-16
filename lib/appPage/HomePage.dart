import 'dart:developer';

import 'package:ai_assis/appPage/Cahtpage.dart';
import 'package:ai_assis/login/signUp.dart';
import 'package:flutter/material.dart';
import 'package:ai_assis/login/FirstPage.dart';



class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _MyAppState();
}



class _MyAppState extends State<HomePage> {
  get onPressed => null;
  bool _showPassword = true;




  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'History',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

      ),

      body:
      Stack( // Assuming bbody uses a Stack widget
        children: [
          // Other elements in bbody (if any)
          Align(
            alignment: Alignment.center, // Center the column
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/Logo_2.png',
                    fit: BoxFit.contain, // Scale image to fit within container
                  ),
                ),


                // Rich text title centered within available space
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to \n',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 40,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'BrainBox',
                          style: TextStyle(
                            color: Color(0xFF141718),
                            fontSize: 40,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // Text with improved readability
                const Flexible(
                  child: Text(
                    'Start chatting with ChattyAI now.\nYou can ask me anything.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF616161),
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      height: 1.2, // Line height for better readability
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    log('Button Pressed');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage()));

                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
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
                            'Get Started',
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
              ],
            )
          ),
        ],
      ),








    );
  }
}


