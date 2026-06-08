import 'package:rizqmart/features/data/data_source/main/cook_tonight_remote_datasource.dart';
import 'package:rizqmart/features/data/data_source/services/gemini_service.dart';
import 'package:rizqmart/features/data/error/exceptions.dart';
import 'package:rizqmart/features/data/model/main/cook_tonight_response_model.dart';
import 'dart:convert';

class CookTonightRemoteDatasourceImpl implements CookTonightRemoteDatasource {
  final GeminiService _geminiService;

  CookTonightRemoteDatasourceImpl(this._geminiService);

  @override
  Future<CookTonightResponseModel> getIngredientsForDish({
    required String dishName,
    required int servings,
  }) async {
    final prompt = _buildPrompt(dishName, servings);
    final text = await _geminiService.generateText(prompt);
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