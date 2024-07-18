import 'package:flutter/material.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          buildPreferenceItem(
            context,
            'Edit Information',
            Icons.edit,
            () {
              // Navigate to Edit Information page
            },
          ),
          buildPreferenceItem(
            context,
            'Password',
            Icons.visibility,
            () {
              // Navigate to Password page
            },
          ),
          buildPreferenceItem(
            context,
            'Invite a Friend',
            Icons.person_add,
            () {
              // Navigate to Invite a Friend page
            },
          ),
          buildPreferenceItem(
            context,
            'Theme Color',
            Icons.palette,
            () {
              // Navigate to Theme Color page
            },
          ),
        ],
      ),
    );
  }

  Widget buildPreferenceItem(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
