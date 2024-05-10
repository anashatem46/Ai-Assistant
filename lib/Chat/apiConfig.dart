import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://8b52-197-56-254-215.ngrok-free.app/process_input';

  Future<String> getAnswer(List<String> question) async {
    Map<String, dynamic> questionData = {'messages': question};
    String jsonData = jsonEncode(questionData);

    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> answerData = jsonDecode(response.body);
      log(response.body);
      return answerData['response']; // Assuming 'answer' is the key in the response JSON
    } else {
      throw Exception('Failed to fetch answer: ${response.statusCode}');
    }
  }
}
