
import 'package:ai_assis/appPage/first_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            'Two-Factor Authentication',
            Icons.security,
            () {
              // Navigate to two-factor authentication page
            },
          ),
          buildListItem(
            context,
            'Manage Trusted Devices',
            Icons.devices,
            () {
              // Navigate to manage trusted devices page
            },
          ),
          buildListItem(
            context,
            'Login Activity',
            Icons.access_time,
            () {
              // Navigate to login activity page
            },
          ),
          buildListItem(
            context,
            'Account Recovery Options',
            Icons.email,
            () {
              // Navigate to account recovery options page
            },
          ),
          buildListItem(
            context,
            'Sign Out from All Sessions',
            Icons.exit_to_app,
            () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          buildListItem(
            context,
            'Delete Account',
            Icons.delete,
            () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await user.delete();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
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
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _changePassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePassword(password);
      // Inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password changed successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  _changePassword(_passwordController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                }
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
