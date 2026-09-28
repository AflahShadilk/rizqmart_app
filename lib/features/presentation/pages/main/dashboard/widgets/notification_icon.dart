import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/app_colors.dart';

// ---------------- Notification Icon Widget ----------------

/// Reusable icon widget for notification items — soft blue-tinted circle,
/// icon color shifts to primary for unread and lighter for read.
class NotificationIcon extends StatelessWidget {
  final String type;
  final bool isRead;

  const NotificationIcon({
    super.key,
    required this.type,
    required this.isRead,
  });

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    // Unread: solid blue tint; read: very faint blue tint
    final Color bgColor = isRead
        ? AppColors.primaryBlue.withValues(alpha: 0.08)
        : AppColors.primaryBlue.withValues(alpha: 0.15);
    final Color iconColor = isRead
        ? AppColors.textSecondary
        : AppColors.primaryBlue;

    IconData icon = Icons.notifications_rounded;
    if (type == 'order') icon = Icons.local_mall_rounded;
    if (type == 'chat') icon = Icons.chat_bubble_rounded;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }
}
