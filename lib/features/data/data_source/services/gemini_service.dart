import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rizqmart/features/data/error/exceptions.dart';

class GeminiService {
  final http.Client _client;

  GeminiService(this._client);

  Future<String> generateText(String prompt) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw const ServerException('Gemini API key is not configured.');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw NetworkException(e.toString());
    }

    if (response.statusCode != 200) {
      throw ServerException(
        'Gemini API error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _extractText(data);
  }

  String _extractText(Map<String, dynamic> data) {
    try {
      final candidates = data['candidates'] as List<dynamic>;
      final parts = candidates[0]['content']['parts'] as List<dynamic>;
      return parts[0]['text'] as String;
    } catch (_) {
      throw const ServerException('Could not parse Gemini response.');
    }
  }
}