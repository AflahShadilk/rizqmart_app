import 'package:rizqmart/features/domain/entities/main/ingredient_entity.dart';

class CookTonightResultEntity {
  final String dishName;
  final int servings;
  final List<IngredientEntity> ingredients;

  const CookTonightResultEntity({
    required this.dishName,
    required this.servings,
    required this.ingredients,
  });
}
