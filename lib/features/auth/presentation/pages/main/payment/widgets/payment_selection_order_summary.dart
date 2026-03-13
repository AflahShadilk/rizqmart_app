import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class PaymentSelectionOrderSummary extends StatelessWidget {
  final double totalCost;

  const PaymentSelectionOrderSummary({
    super.key,
    required this.totalCost,
  });
@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: context.ts.bodyMedium,
              ),
              Text(
                '₹${totalCost.toStringAsFixed(2)}',
                style: context.ts.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
