import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class EmptySavedCardsState extends StatelessWidget {
  final VoidCallback onAddCard;

  const EmptySavedCardsState({
    super.key,
    required this.onAddCard,
  });
@override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, size: 64, color: context.cs.outline),
          16.h,
          Text('No saved cards found', style: context.ts.titleMedium),
          8.h,
          TextButton.icon(
            onPressed: onAddCard,
            icon: const Icon(Icons.add),
            label: const Text('Add New Card'),
          ),
        ],
      ),
    );
  }
}
