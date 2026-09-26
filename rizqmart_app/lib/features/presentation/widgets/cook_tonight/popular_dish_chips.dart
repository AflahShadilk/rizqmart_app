import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class PopularDishChips extends StatelessWidget {
  final ValueChanged<String> onDishSelected;

  static const _dishes = [
    'Chicken Karahi',
    'Biryani',
    'Dal Makhani',
    'Nihari',
    'Haleem',
    'Palak Paneer',
    'Seekh Kebab',
    'Pulao',
  ];

  const PopularDishChips({super.key, required this.onDishSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _dishes.map((dish) {
        return GestureDetector(
          onTap: () => onDishSelected(dish),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: context.cs.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dish,
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
