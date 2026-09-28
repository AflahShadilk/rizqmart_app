import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';

// ---------------- Notification Dropdown Footer Widget ----------------

/// Footer widget for the notification dropdown — "View all" plain blue text link, centered.
class NotificationDropdownFooter extends StatelessWidget {
  final VoidCallback? onClose;

  const NotificationDropdownFooter({super.key, this.onClose});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClose?.call();
        Navigator.pushNamed(context, '/notifications');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View all notifications',
              style: GoogleFonts.manrope(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: AppColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
