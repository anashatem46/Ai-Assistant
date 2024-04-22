import 'dart:developer';

import 'package:ai_assis/Chat/Cahtpage.dart';
import 'package:ai_assis/Chat/chatGemini.dart';
import 'package:ai_assis/appPage/HomePage.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  int selectedIndex = 0;
  late List<Widget> page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (val) {
          log('Index: $val');
          setState(() {
            selectedIndex = val;
          });
        },
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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      )
    );
  }
  Widget buildBody() {
    switch (selectedIndex) {
      case 0:
        return buildHomePage(context);
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }



}
