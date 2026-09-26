import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class DishInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const DishInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSubmitted(),
      style: context.ts.bodyLarge,
      decoration: InputDecoration(
        hintText: 'e.g. Chicken Karahi, Biryani...',
        hintStyle: context.ts.bodyLarge?.copyWith(
          color: context.cs.onSurface.withValues(alpha: 0.4),
        ),
        prefixIcon: Icon(Icons.restaurant_menu, color: context.cs.primary),
        suffixIcon: IconButton(
          icon: Icon(Icons.search_rounded, color: context.cs.primary),
          onPressed: onSubmitted,
          tooltip: 'Get Ingredients',
        ),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.cs.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
