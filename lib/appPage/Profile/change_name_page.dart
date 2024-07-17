import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeNamePage extends StatefulWidget {
  @override
  _ChangeNamePageState createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _changeName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name changed successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'New Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () => _changeName(_nameController.text),
              child: Text('Change Name', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}