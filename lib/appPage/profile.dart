import 'package:ai_assis/appPage/preferences_page.dart';
import 'package:ai_assis/auth/Intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@override
Widget buildProfilePage(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
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
              radius: 80,
              backgroundImage: AssetImage(
                  'assets/images/Rectangle1.png'), // Path to your image
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'User Name',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        buildListItem(
          context,
          'Preferences',
          Icons.settings,
              () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const PreferencesPage())); // Navigate to preferences page
          },
        ),
        buildListItem(
          context,
          'Account Security',
          Icons.lock,
              () {
            // Navigate to account security page
          },
        ),
        buildListItem(
          context,
          'Logout',
          Icons.exit_to_app,
              () async {
            final savedContext = context; // Save the context before the async call
            await FirebaseAuth.instance.signOut();
            if (savedContext.mounted) {
              Navigator.of(savedContext).pushReplacement(
                  MaterialPageRoute(builder: (context) => const IntroPage()));
            }
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
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: onTap,
  );
}
