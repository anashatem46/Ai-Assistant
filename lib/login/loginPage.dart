import 'package:ai_assis/appPage/FirstPage.dart';
import 'package:ai_assis/login/signUp.dart';
import 'package:flutter/material.dart';



class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _MyAppState();
}



class _MyAppState extends State<loginPage> {
  get onPressed => null;
  bool _showPassword = true;




  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: Container(
        child: SafeArea(
        child: SingleChildScrollView(
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
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'hello@example.com', // Placeholder text
                        //isDense: true, // Compact text field for a cleaner look
                        contentPadding: const EdgeInsets.all(8.0), // Adjust content padding
                      ),
                      keyboardType: TextInputType.emailAddress, // Set keyboard type for email input
                    ),



                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(top: 20.0, left:40.0,right: 50,bottom: 50), // Use double precision
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
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
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
              MaterialButton(
                onPressed: (){
                  print('Button Pressed');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));

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
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child:  Row(
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
                        print('Button pressed!');
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>
                                const signUp()));
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
        ),

    );
  }
}








































