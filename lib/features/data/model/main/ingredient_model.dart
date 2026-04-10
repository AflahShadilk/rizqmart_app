import 'package:rizqmart/features/domain/entities/main/ingredient_entity.dart';

class IngredientModel extends IngredientEntity {
  const IngredientModel({
    required super.name,
    required super.quantity,
    required super.category,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      category: json['category'] as String,
    );
  }
}
