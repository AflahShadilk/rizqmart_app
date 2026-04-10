import 'package:flutter/material.dart';
import 'package:rizqmart/features/domain/entities/main/ingredient_entity.dart';
import 'package:rizqmart/features/presentation/widgets/cook_tonight/ingredient_tile.dart';

class IngredientList extends StatelessWidget {
  final List<IngredientEntity> ingredients;

  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return IngredientTile(ingredient: ingredients[index]);
      },
    );
  }
}
