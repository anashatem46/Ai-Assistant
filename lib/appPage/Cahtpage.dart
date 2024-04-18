import 'dart:developer';

import 'package:ai_assis/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBarWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
      padding: const EdgeInsets.only(left: 20),
            child: InkWell(



              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 60,
                height: 60,



                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(10, 9), // changes position of shadow
                    ),
                  ],
                ),
                child:const Center(child:  Icon(Icons.arrow_back_ios_new)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                log('Button Pressed');
              },

                child:const Center(child:  Icon(Icons.more_horiz,size: 50,color: Colors.grey,),),
              ),
            ),


        ],
      ),),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Message $index'),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            child: TextField(

              decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                fillColor:Colors.white,
                border: OutlineInputBorder(


                  borderRadius: BorderRadius.circular(7.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.all(8.0),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {

                    log('Button Pressed');
                  },
                ),
              ),
              obscureText: false,
            ),
          ),
        ],
      )
    );
  }
}

