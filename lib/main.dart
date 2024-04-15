import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  get onPressed => null;
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Container(
          child:  Column(
            children: [
              Container(

                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(top: 180.0, left: 40.0), // Use double precision
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
                        height: 1.0,

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
                  margin: const EdgeInsets.only(top: 40.0, left:40.0,right: 50), // Use double precision
                  child:  Column(
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
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'hello@example.com', // Placeholder text
                          //isDense: true, // Compact text field for a cleaner look
                          contentPadding: EdgeInsets.all(8.0), // Adjust content padding
                        ),
                        keyboardType: TextInputType.emailAddress, // Set keyboard type for email input
                      ),



                    ],
                  ),
                ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(top: 20.0, left:40.0,right: 50), // Use double precision
                child:  Column(
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



                    TextField(
                      decoration: InputDecoration(

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(8.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
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


            ],
          ),
        ),
      ),
    );
  }
}


















































