import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class PaymentProcessingLoadingState extends StatelessWidget {
  final String message;

  const PaymentProcessingLoadingState({
    super.key,
    required this.message,
  });
@override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.cs.primary,
            strokeWidth: 3,
          ),
          16.h,
          Text(
            message,
            style: context.ts.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          8.h,
          Text(
            'Please do not close this screen',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
