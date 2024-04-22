import 'package:ai_assis/appPage/preferencespage.dart';
import 'package:ai_assis/auth/IntroPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

@override
Widget buildProfilePage(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
      centerTitle: true,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius:80,
              backgroundImage: AssetImage(
                  'assets/images/Rectangle1.png'), // Path to your image
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'User Name',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize:20 , fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        buildListItem(
          context,
          'Preferences',
          Icons.settings,
              () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PreferencesPage())); // Navigate to preferences page
          },
        ),

        Divider(),
        buildListItem(
          context,
          'Account Security',
          Icons.lock,
          () {
            // Navigate to account security page
          },
        ),
        Divider(),
        buildListItem(
          context,
          'Logout',
          Icons.exit_to_app,
          () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Intropage()));
          },
        ),
      ],
    ),
  );
}

Widget buildListItem(
    BuildContext context, String title, IconData icon, Function() onTap) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: Icon(Icons.arrow_forward_ios),
    onTap: onTap,
  );
}
