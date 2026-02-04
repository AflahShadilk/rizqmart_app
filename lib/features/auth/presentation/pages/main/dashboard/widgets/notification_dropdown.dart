import 'dart:ui';
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
      constraints: const BoxConstraints(maxHeight: 380),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.cs.surface.withOpacity(0.88),
                  context.cs.surface.withOpacity(0.78),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Divider(height: 1, color: context.cs.outlineVariant.withOpacity(0.12)),
                Flexible(
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoadingState) {
                        return SizedBox(
                          height: 100,
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
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          itemCount: state.notifications.length > 5 ? 5 : state.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = state.notifications[index];
                            return _buildNotificationItem(context, notification);
                          },
                        );
                      }
                      if (state is NotificationErrorState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Failed to load notifications', 
                              style: context.ts.bodySmall?.copyWith(
                                color: context.cs.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Divider(height: 1, color: context.cs.outlineVariant.withOpacity(0.12)),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final bool isRead = notification.isRead;
    
    return Material(
      color: isRead ? Colors.transparent : context.cs.primary.withOpacity(0.05),
      child: InkWell(
        onTap: () => _handleNotificationTap(context, notification),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(context, notification.type, isRead),
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

  Widget _buildIcon(BuildContext context, String type, bool isRead) {
    Color iconColor = isRead ? context.cs.secondary : context.cs.primary;
    Color bgColor = isRead ? context.cs.secondaryContainer.withOpacity(0.4) : context.cs.primaryContainer.withOpacity(0.6);
    IconData icon = Icons.notifications_rounded;
    
    if (type == 'order') icon = Icons.local_mall_rounded;
    if (type == 'chat') icon = Icons.chat_bubble_rounded;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.04),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications', 
            style: context.ts.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          InkWell(
            onTap: () {
               final userId = FirebaseAuth.instance.currentUser?.uid;
               if (userId != null) {
                 context.read<NotificationBloc>().add(MarkAllAsReadEvent(userId));
               }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.cs.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Mark all read', 
                style: context.ts.labelSmall?.copyWith(
                  color: context.cs.primary, 
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
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
         padding: const EdgeInsets.symmetric(vertical: 10),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Colors.transparent,
               Colors.white.withOpacity(0.02),
             ],
           ),
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(
               'View all',
               style: context.ts.labelMedium?.copyWith(
                 color: context.cs.primary,
                 fontWeight: FontWeight.w600,
                 fontSize: 12,
               ),
             ),
             4.w,
             Icon(
               Icons.arrow_forward_rounded, 
               size: 14, 
               color: context.cs.primary,
             ),
           ],
         ),
       ),
     );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerHighest.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded, 
                size: 26, 
                color: context.cs.outline.withOpacity(0.7),
              ),
            ),
            12.h,
            Text(
              "All caught up!", 
              style: context.ts.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            4.h,
            Text(
              'No new notifications', 
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.outline,
                fontSize: 12,
              ),
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