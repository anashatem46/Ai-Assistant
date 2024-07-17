// AccountSecurityPage.dart
import 'package:ai_assis/appPage/Profile/change_name_page.dart';
import 'package:flutter/material.dart';
import 'change_password_page.dart'; // Ensure you have this file created

class AccountSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Security'),
      ),
      body: ListView(
        children: [
          buildListItem(
            context,
            'Change Password',
            Icons.lock,
            () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
          ),
          buildListItem(
            context,
            'Change Name',
            Icons.edit,
            () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNamePage(),
              ));
            },
          ),
          // Add other list items here for two-factor authentication, etc.
        ],
      ),
    );
  }

  Widget buildListItem(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile( leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}