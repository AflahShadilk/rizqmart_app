import 'package:rizqmart/features/data/model/main/ingredient_model.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';

class CookTonightResponseModel extends CookTonightResultEntity {
  const CookTonightResponseModel({
    required super.dishName,
    required super.servings,
    required super.ingredients,
  });

  factory CookTonightResponseModel.fromIngredientList({
    required String dishName,
    required int servings,
    required List<dynamic> json,
  }) {
    return CookTonightResponseModel(
      dishName: dishName,
      servings: servings,
      ingredients: json
          .map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
