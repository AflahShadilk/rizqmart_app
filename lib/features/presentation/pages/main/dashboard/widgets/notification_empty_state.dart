import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Notification Empty State Widget ----------------

/// Placeholder shown when the user has no notifications.
/// Styled with the design system: soft blue-tinted icon circle, textPrimary heading, textSecondary body.
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Soft blue-tinted circle matching the NotificationIcon pattern
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.primaryBlue,
            ),
          ),
          24.h,
          Text(
            'No notifications yet',
            style: GoogleFonts.manrope(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          8.h,
          Text(
            "You're all caught up! We'll let you know\nwhen something new arrives.",
            style: GoogleFonts.manrope(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
