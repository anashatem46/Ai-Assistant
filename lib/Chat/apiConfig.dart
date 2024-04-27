import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static final String baseUrl = 'https://f590-34-143-189-162.ngrok-free.app/predict/';

  Future<String> getAnswer(String question) async {
    Map<String, dynamic> questionData = {'text': question};
    String jsonData = jsonEncode(questionData);

    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> answerData = jsonDecode(response.body);
      return answerData['response'] as String; // Assuming 'answer' is the key in the response JSON
    } else {
      throw Exception('Failed to fetch answer: ${response.statusCode}');
    }
  }
}
