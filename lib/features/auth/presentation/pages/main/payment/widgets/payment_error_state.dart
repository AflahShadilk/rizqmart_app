import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Payment Error State ----------------

/// A visual error display with retry and navigation options after a payment failure.
class PaymentErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  const PaymentErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onGoHome,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------------- Error Icon ----------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cs.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 80,
                  color: context.cs.error,
                ),
              ),
              24.h,

              // ---------------- Error Title ----------------
              Text(
                'Payment Failed',
                style: context.ts.headlineSmall?.copyWith(
                  color: context.cs.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.h,

              // ---------------- Error Message ----------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cs.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.cs.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.ts.bodyMedium,
                ),
              ),
              24.h,

              // ---------------- Retry Button ----------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MainButton(
                  label: 'Try Again',
                  onPress: onRetry,
                  color: context.cs.primary,
                  textColor: context.cs.surface,
                ),
              ),
              12.h,

              // ---------------- Go Home Button ----------------
              TextButton(
                onPressed: onGoHome,
                child: Text(
                  'Go to Home',
                  style: context.ts.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
