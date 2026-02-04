
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';


class NotificationDropdown extends StatelessWidget {
  const NotificationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, 
      constraints: const BoxConstraints(maxHeight: 450),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: context.cs.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(color: context.cs.outlineVariant.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Flexible(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoadingState) {
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.cs.primary,
                        )
                      ),
                    );
                  }
                  if (state is NotificationLoadedState) {
                    if (state.notifications.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return _buildNotificationItem(context, notification);
                      },
                    );
                  }
                  if (state is NotificationErrorState) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(child: Text('Failed to load notifications', style: context.ts.bodySmall)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const Divider(height: 1),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final bool isRead = notification.isRead;
    
    return Material(
      color: isRead ? Colors.transparent : context.cs.primary.withOpacity(0.04),
      child: InkWell(
        onTap: () => _handleNotificationTap(context, notification),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // More breathing room
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
                        if (!isRead) 
                          Container(
                            width: 8,
                            height: 8,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.h,
                    Text(
                      _timeAgo(notification.timestamp),
                      style: context.ts.labelSmall?.copyWith(
                        color: context.cs.outline,
                        fontSize: 11
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
    Color bgColor = isRead ? context.cs.secondaryContainer.withOpacity(0.5) : context.cs.primaryContainer;
    IconData icon = Icons.notifications_rounded;
    
    if (type == 'order') icon = Icons.local_mall_rounded;
    if (type == 'chat') icon = Icons.chat_bubble_rounded;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12), // Squircle shape
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications', 
            style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)
          ),
          InkWell(
            onTap: () {
               final userId = FirebaseAuth.instance.currentUser?.uid;
               if (userId != null) {
                 context.read<NotificationBloc>().add(MarkAllAsReadEvent(userId));
               }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Mark all read', 
                style: context.ts.labelMedium?.copyWith(
                  color: context.cs.primary, 
                  fontWeight: FontWeight.w600
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
     return InkWell(
       onTap: () {
         // Navigate to full page
       },
       child: Container(
         padding: const EdgeInsets.symmetric(vertical: 14),
         alignment: Alignment.center,
         color: context.cs.surface, // Ensure clickable area has color
         child: Text(
           'View all notifications',
           style: context.ts.labelLarge?.copyWith(
             color: context.cs.primary,
             fontWeight: FontWeight.w600
            ),
         ),
       ),
     );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerHighest.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_none_rounded, size: 32, color: context.cs.outline),
            ),
            16.h,
            Text(
              "You're all caught up!", 
              style: context.ts.titleSmall?.copyWith(fontWeight: FontWeight.w600)
            ),
            4.h,
            Text(
              'No new notifications at the moment.', 
              style: context.ts.bodySmall?.copyWith(color: context.cs.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
}
