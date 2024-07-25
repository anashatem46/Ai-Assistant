import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeApiPage extends StatefulWidget {
  const ChangeApiPage({super.key});

  @override
  State<ChangeApiPage> createState() => _ChangeApiPageState();
}

class _ChangeApiPageState extends State<ChangeApiPage> {
  TextEditingController? _apiController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApiLink();
  }

  Future<void> _loadApiLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String currentApiLink = prefs.getString('api_link') ?? '';
      _apiController = TextEditingController(text: currentApiLink);
      _isLoading = false;
    });
  }

  Future<void> _changeApi(String apiLink) async {
    apiLink = apiLink.trim();
    if (apiLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API link cannot be empty or only spaces')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_link', apiLink);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New API Link saved: $apiLink')),
    );
    log("New API Link saved: $apiLink");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change API link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            TextField(
              controller: _apiController,
              decoration: const InputDecoration(labelText: 'New API link'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                _changeApi(_apiController!.text);
              },
              child: const Text('Change API',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
