import 'dart:developer';

import 'package:ai_assis/appPage/chat_history_screen.dart';
import 'package:ai_assis/appPage/home_page.dart';
import 'package:ai_assis/appPage/profile.dart';
import 'package:ai_assis/appPage/tools.dart';

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
        ));
  }

  Widget buildBody() {
    switch (selectedIndex) {
      case 0:
        return buildHomePage(context);
        case 1:
        return buildToolsPage(context);
          case 2:
        return ChatHistoryScreen ();
      case 3 :
        return ProfilePage();
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }
}
