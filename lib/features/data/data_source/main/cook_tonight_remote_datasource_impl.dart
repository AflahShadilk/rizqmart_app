import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rizqmart/features/data/data_source/main/cook_tonight_remote_datasource.dart';
import 'package:rizqmart/features/data/error/exceptions.dart';
import 'package:rizqmart/features/data/model/main/cook_tonight_response_model.dart';

class CookTonightRemoteDatasourceImpl implements CookTonightRemoteDatasource {
  final http.Client _client;

  CookTonightRemoteDatasourceImpl(this._client);

  @override
  Future<CookTonightResponseModel> getIngredientsForDish({
    required String dishName,
    required int servings,
  }) async {
    final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw const ServerException('Anthropic API key is not configured.');
    }

    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': '2023-06-01',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'claude-sonnet-4-20250514',
              'max_tokens': 1024,
              'messages': [
                {'role': 'user', 'content': _buildPrompt(dishName, servings)},
              ],
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw NetworkException(e.toString());
    }

    if (response.statusCode != 200) {
      throw ServerException(
        'Anthropic API error ${response.statusCode}: ${response.body}',
      );
    }

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ServerException('Received malformed JSON from Anthropic.');
    }

    final text = _extractText(data);
    final parsed = _parseIngredients(text);

    return CookTonightResponseModel.fromIngredientList(
      dishName: dishName,
      servings: servings,
      json: parsed,
    );
  }

  String _buildPrompt(String dishName, int servings) {
    return 'You are a grocery assistant for Rizq Mart. '
        'The user wants to cook "$dishName" for $servings people.\n\n'
        'Return ONLY a raw JSON array. No markdown. No explanation. No code fences.\n\n'
        'Each item must follow this exact structure:\n'
        '{"name": "string", "quantity": "string", "category": "string"}\n\n'
        'Categories must be one of: Meat, Vegetables, Spices, Dairy, Grains, Pantry.\n'
        'Max 10 ingredients. Use simple grocery store names only.';
  }

  String _extractText(Map<String, dynamic> data) {
    final content = data['content'] as List<dynamic>;
    return content
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join();
  }

  List<dynamic> _parseIngredients(String text) {
    try {
      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      return jsonDecode(cleaned) as List<dynamic>;
    } catch (_) {
      throw const ServerException(
        'Could not parse ingredients from AI response.',
      );
    }
  }
}
