import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Dropdown Notification Empty State Widget ----------------

/// Minimal placeholder shown inside the dropdown when there are no notifications.
/// Matches the same visual language as NotificationEmptyState (blue-tinted circle).
class DropdownNotificationEmptyState extends StatelessWidget {
  const DropdownNotificationEmptyState({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Soft blue-tinted circle — same language as NotificationIcon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: AppColors.primaryBlue,
              ),
            ),
            12.h,
            Text(
              'No notifications yet',
              style: GoogleFonts.manrope(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            4.h,
            Text(
              "You're all caught up!",
              style: GoogleFonts.manrope(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
