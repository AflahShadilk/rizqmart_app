import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Payment Success State ----------------

/// A visual confirmation displayed when payment completes successfully.
class PaymentSuccessState extends StatelessWidget {
  final String orderId;

  const PaymentSuccessState({
    super.key,
    required this.orderId,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------------- Success Icon ----------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.cs.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: context.cs.success,
              ),
            ),
            24.h,

            // ---------------- Success Message ----------------
            Text(
              'Payment Successful!',
              style: context.ts.headlineSmall?.copyWith(
                color: context.cs.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.h,
            Text(
              'Your order has been placed',
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            16.h,

            // ---------------- Order ID ----------------
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.cs.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.cs.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Order ID',
                    style: context.ts.labelSmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  4.h,
                  Text(
                    orderId,
                    style: context.ts.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
