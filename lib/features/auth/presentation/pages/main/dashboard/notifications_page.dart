import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/routes/app_routes.dart';

/// A page widget that lists and manages the user's incoming push notifications and alerts.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                context.read<NotificationBloc>().add(ClearAllNotificationsEvent(userId));
              }
            },
            child: Text(
              'Clear All',
              style: context.ts.labelMedium?.copyWith(
                color: context.cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          8.w,
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationLoadedState) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState(context);
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: context.cs.outlineVariant.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _buildNotificationItem(context, notification);
              },
            );
          }
          if (state is NotificationErrorState) {
            return Center(
              child: Text(
                'Failed to load notifications',
                style: context.ts.bodyMedium?.copyWith(color: context.cs.error),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final bool isRead = notification.isRead;
    
    return Material(
      color: isRead ? Colors.transparent : context.cs.primary.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => _handleNotificationTap(context, notification),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(context, notification.type, isRead),
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

  Widget _buildIcon(BuildContext context, String type, bool isRead) {
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.cs.surfaceContainerHighest.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded, 
              size: 48, 
              color: context.cs.outline.withValues(alpha: 0.7),
            ),
          ),
          20.h,
          Text(
            "All caught up!", 
            style: context.ts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          8.h,
          Text(
            'No new notifications', 
            style: context.ts.bodyMedium?.copyWith(
              color: context.cs.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, dynamic notification) {
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
}
