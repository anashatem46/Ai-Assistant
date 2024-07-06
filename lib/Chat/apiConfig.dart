import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://9bf0-102-44-226-224.ngrok-free.app/ask/';

  Future<String> getAnswer(String question) async {
    Map<String, dynamic> questionData = {
      "user_id": "wweeqwehi",
      "question": question
    };
    log('Sending question: $questionData');
    String jsonData = jsonEncode(questionData);

    Uri url = Uri.parse(baseUrl);
    http.Response response = await http.post(
      url,
      body: jsonData,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 307 || response.statusCode == 302) {
      final String? redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        url = Uri.parse(redirectUrl);
        response = await http.post(
          url,
          body: jsonData,
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        throw Exception('Redirect response without location header');
      }
    }

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> answerData = jsonDecode(response.body);
        log('Response: ${response.body}');
        if (answerData.containsKey('response')) {
          return answerData['response'] as String;
        } else {
          throw Exception('Response does not contain "response" key.');
        }
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      throw Exception('Failed to fetch answer: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }
}
