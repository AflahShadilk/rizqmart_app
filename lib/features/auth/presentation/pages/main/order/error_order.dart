

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';

Future<dynamic> orderErrorDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Lottie.asset(
                  "assets/lottie/Shopping bag - error.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                16.h,
                ReusableText(
                  texts: 'Oops! Order failed',
                  titleSize: context.ts.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.error
                  ),
                ),
                8.h,
                ReusableText(
                  texts: message,
                  titleSize: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                24.h,
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: MainButton(
                    label: 'Please try again',
                    onPress: () => Navigator.of(context).pop(),
                    color: context.cs.primary,
                    textColor: context.cs.surface,
                  ),
                ),
                12.h,
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.navigationBar);
                  },
                  child: Text(
                    'Back to Home',
                    style: context.ts.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}