import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';

/// A compact increment/decrement counter widget for adjusting cart item quantity.
class CartQuantityCounter extends StatelessWidget {

  // ---------------- Variables ----------------

  final String cartItemId;
  final int count;

  const CartQuantityCounter({
    super.key,
    required this.cartItemId,
    required this.count,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final isMinusDisabled = count <= 1;
    final isPlusDisabled = count >= 20;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.cs.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------- Decrement Button ----------------
          InkWell(
            onTap: isMinusDisabled
                ? null
                : () {
                    context
                        .read<CartBloc>()
                        .add(DecrementQuantityEvent(cartItemId));
                  },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              bottomLeft: Radius.circular(7),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.remove,
                color: isMinusDisabled
                    ? context.cs.primary.withValues(alpha: 0.3)
                    : context.cs.error,
                size: 18,
              ),
            ),
          ),

          // ---------------- Count Display ----------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.cs.onSurface,
              ),
            ),
          ),

          // ---------------- Increment Button ----------------
          InkWell(
            onTap: isPlusDisabled
                ? null
                : () {
                    context.read<CartBloc>().add(IncrementQuantityEvent(cartItemId));
                  },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add,
                color: isPlusDisabled
                    ? context.cs.primary.withValues(alpha: 0.3)
                    : context.cs.success,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
