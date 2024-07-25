import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../user_info_from_firebase.dart';

class ApiClient {
  static const String defaultBaseUrl = 'https://de0b-197-56-219-0.ngrok-free.app/ask';

  var userId = UserData.getUserId() ?? '12345';

  Future<String> _getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_link') ?? defaultBaseUrl;
  }

  Future<Map<String, dynamic>> getAnswer(
      String question, {
        File? file,
      }) async {
    final baseUrl = await _getBaseUrl();
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    // Add text fields
    request.fields['user_id'] = userId;
    request.fields['question'] = question;

    if (file != null) {
      // Add file field
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));
    }

    log('Sending request: ${request.fields} with file: ${file?.path}');

    // Send the request
    var streamedResponse = await request.send();

    // Get the response
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 307 || response.statusCode == 302) {
      final String? redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        var redirectedRequest =
        http.MultipartRequest('POST', Uri.parse(redirectUrl));

        // Add text fields again
        redirectedRequest.fields['user_id'] = userId;
        redirectedRequest.fields['question'] = question;

        if (file != null) {
          // Add file field again
          redirectedRequest.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path,
          ));
        }

        log('Redirecting request to: $redirectUrl');
        streamedResponse = await redirectedRequest.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        throw Exception('Redirect response without location header');
      }
    }

    if (response.statusCode == 200) {
      try {
        if (response.headers['content-type']?.startsWith('image/') ?? false) {
          return {'response_type': 'image', 'response': response.bodyBytes};
        } else {
          final Map<String, dynamic> answerData = jsonDecode(response.body);
          log('Response: ${response.body}');
          if (answerData.containsKey('response')) {
            return {
              'response_type': 'text',
              'response': answerData['response']
            };
          } else {
            throw Exception('Response does not contain "response" key.');
          }
        }
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      log('Failed to fetch answer: ${response.statusCode}, ${response.reasonPhrase}, ${response.body}');
      throw Exception(
          'Failed to fetch answer: ${response.statusCode}, ${response.reasonPhrase}, ${response.body}');
    }
  }
}
