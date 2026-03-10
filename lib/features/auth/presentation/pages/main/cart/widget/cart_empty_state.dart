import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';

/// Displays a friendly empty state when the user's cart has no items.
class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: context.cs.onSurface.withValues(alpha: .3),
          ),
          16.h,
          ReusableText(
            texts: 'Your cart is empty',
            titleSize: context.ts.titleLarge?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          8.h,
          ReusableText(
            texts: 'Add items to get started',
            titleSize: context.ts.bodyMedium?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
