import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_icon.dart';

// ---------------- Dropdown Notification Item Widget ----------------

/// Widget representing a single notification entry in the dropdown list.
class DropdownNotificationItem extends StatelessWidget {
  final dynamic notification;

  const DropdownNotificationItem({
    super.key,
    required this.notification,
  });

// ---------------- Helper Methods ----------------

  void _handleNotificationTap(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && !notification.isRead) {
      context.read<NotificationBloc>().add(
        MarkAsReadEvent(userId: userId, notificationId: notification.id)
      );
    }
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    final bool isRead = notification.isRead;
    
    return Material(
      color: isRead ? Colors.transparent : context.cs.primary.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => _handleNotificationTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationIcon(type: notification.type, isRead: isRead),
              10.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: context.ts.bodySmall?.copyWith(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                              color: context.cs.onSurface,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        4.w,
                        if (!isRead) 
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: context.cs.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    3.h,
                    Text(
                      notification.body,
                      style: context.ts.bodySmall?.copyWith(
                        color: context.cs.onSurfaceVariant,
                        height: 1.35,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Text(
                      _timeAgo(notification.timestamp),
                      style: context.ts.labelSmall?.copyWith(
                        color: context.cs.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
