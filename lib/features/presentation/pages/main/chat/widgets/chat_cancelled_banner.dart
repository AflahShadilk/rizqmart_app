import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

/// An overlay banner shown when the order is cancelled, preventing further chat.
class ChatCancelledBanner extends StatelessWidget {
  const ChatCancelledBanner({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.chatErrorBackground,
      child: Column(
        children: [
          Icon(Icons.block, color: AppColors.chatErrorIcon),
          8.h,
          Text(
            'This chat is closed because the order was cancelled.',
            style: context.ts.bodyMedium?.copyWith(color: AppColors.chatErrorText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
