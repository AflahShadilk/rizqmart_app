import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class NotificationIcon extends StatelessWidget {
  final String type;
  final bool isRead;

  const NotificationIcon({
    super.key,
    required this.type,
    required this.isRead,
  });
@override
  Widget build(BuildContext context) {
    Color iconColor = isRead ? context.cs.secondary : context.cs.primary;
    Color bgColor = isRead ? context.cs.secondaryContainer.withValues(alpha: 0.4) : context.cs.primaryContainer.withValues(alpha: 0.6);
    IconData icon = Icons.notifications_rounded;
    
    if (type == 'order') icon = Icons.local_mall_rounded;
    if (type == 'chat') icon = Icons.chat_bubble_rounded;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }
}
