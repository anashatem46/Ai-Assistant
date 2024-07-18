import 'package:flutter/material.dart';
import 'change_name_page.dart';
import 'change_password_page.dart'; // Ensure you have this file created

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Security'),
      ),
      body: ListView(
        children: [
          buildListItem(
            context,
            'Change Password',
            Icons.lock,
            () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChangePasswordPage(),
              ));
            },
          ),
          buildListItem(
            context,
            'Change Name',
            Icons.edit,
            () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChangeNamePage(),
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
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
