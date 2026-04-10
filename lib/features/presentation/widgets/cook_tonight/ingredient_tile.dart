import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/ingredient_entity.dart';

class IngredientTile extends StatelessWidget {
  final IngredientEntity ingredient;

  const IngredientTile({super.key, required this.ingredient});

  static const _categoryColors = {
    'Meat': Color(0xFFFFEBEE),
    'Vegetables': Color(0xFFE8F5E9),
    'Spices': Color(0xFFFFF3E0),
    'Dairy': Color(0xFFE3F2FD),
    'Grains': Color(0xFFFFF8E1),
    'Pantry': Color(0xFFF3E5F5),
  };

  static const _categoryTextColors = {
    'Meat': Color(0xFFC62828),
    'Vegetables': Color(0xFF2E7D32),
    'Spices': Color(0xFFE65100),
    'Dairy': Color(0xFF1565C0),
    'Grains': Color(0xFFF57F17),
    'Pantry': Color(0xFF6A1B9A),
  };

  @override
  Widget build(BuildContext context) {
    final bgColor =
        _categoryColors[ingredient.category] ?? context.cs.surfaceContainerHighest;
    final textColor =
        _categoryTextColors[ingredient.category] ?? context.cs.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.cs.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _categoryIcon(ingredient.category),
              size: 20,
              color: textColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: context.ts.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ingredient.quantity,
                  style: context.ts.bodySmall?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              ingredient.category,
              style: context.ts.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Meat':
        return Icons.set_meal_rounded;
      case 'Vegetables':
        return Icons.eco_rounded;
      case 'Spices':
        return Icons.local_fire_department_rounded;
      case 'Dairy':
        return Icons.water_drop_rounded;
      case 'Grains':
        return Icons.grain_rounded;
      default:
        return Icons.kitchen_rounded;
    }
  }
}
