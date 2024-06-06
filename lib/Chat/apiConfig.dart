import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://da2b-35-226-171-222.ngrok-free.app/generate';

  Future<String> getAnswer(question) async {
    Map<String, dynamic> questionData = {'text':question};
    log('Sending question: $questionData');
    String jsonData = jsonEncode(questionData);

    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> answerData = jsonDecode(response.body);
      log(response.body);
      return answerData["response"]; // Assuming 'answer' is the key in the response JSON
    } else {
      throw Exception('Failed to fetch answer: ${response.statusCode}');
    }
  }
}
