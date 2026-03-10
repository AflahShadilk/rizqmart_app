
import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Error Dialog ----------------

void orderErrorDialog(BuildContext context, {String? errorMessage}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.cs.surface,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Error Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.error500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              24.h,
              
              // Error Title
              Text(
                'Something went wrong!',
                style: context.ts.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              16.h,
              
              // Error Message
              Text(
                errorMessage ?? 'An unexpected error occurred while processing your order. Please try again.',
                style: context.ts.bodyMedium?.copyWith(
                  color: context.cs.onSurface.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
              32.h,
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.navigationBar, (route) => false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Home',
                        style: TextStyle(color: context.cs.primary),
                      ),
                    ),
                  ),
                  16.w,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pop(dialogContext); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}