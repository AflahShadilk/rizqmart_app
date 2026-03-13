import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class PaymentInfoBanner extends StatelessWidget {
  const PaymentInfoBanner({super.key});
@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.cs.primary,
            size: 20,
          ),
          12.w,
          Expanded(
            child: Text(
              'You can change payment method during checkout',
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
