import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget buildLoadingIndicatorWidget() {
  return
 Center(
      child:Lottie.asset('assets/lottie/Animation_Loading.json'),
  );
}
Widget buildMessageLoadingIndicator() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16.0),
        // Text(
        //   'Loading messages...',
        //   style: TextStyle(fontSize: 16.0),
        // ),
      ],
    ),
  );
}