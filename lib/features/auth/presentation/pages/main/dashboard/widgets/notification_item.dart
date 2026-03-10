import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_icon.dart';

// ---------------- Notification Item Widget ----------------

/// Widget representing a single notification entry in the notifications list.
class NotificationItem extends StatelessWidget {
  final dynamic notification;

  const NotificationItem({
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

    if (notification.type == 'order') {
      Navigator.pushNamed(context, AppRoutes.orders);
    } else if (notification.type == 'chat') {
       final data = notification.data as Map<String, dynamic>?;
       final orderId = data?['orderId'] ?? notification.referenceId;
       if (orderId != null && orderId.isNotEmpty) {
         Navigator.pushNamed(context, AppRoutes.chat, arguments: {
           'orderId': orderId,
           'orderDisplayId': data?['orderDisplayId'] ?? '',
           'deliveryPartnerName': data?['deliveryPartnerName'] ?? '',
           'productId': data?['productId'] ?? '',
           'productName': data?['productName'] ?? '',
           'productImage': data?['productImage'] ?? '',
           'sellerId': data?['sellerId'] ?? '',
           'orderStatus': data?['orderStatus'] ?? 'active',
         });
       } else {
         Navigator.pushNamed(context, AppRoutes.orders);
       }
    }
  }

  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationIcon(type: notification.type, isRead: isRead),
              12.w,
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
                            style: context.ts.bodyMedium?.copyWith(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                              color: context.cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.w,
                        if (!isRead) 
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: context.cs.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    4.h,
                    Text(
                      notification.body,
                      style: context.ts.bodySmall?.copyWith(
                        color: context.cs.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    6.h,
                    Text(
                      _timeAgo(notification.timestamp),
                      style: context.ts.labelSmall?.copyWith(
                        color: context.cs.outline,
                        fontSize: 11,
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
