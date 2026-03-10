import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_empty_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_item.dart';

// ---------------- Controllers & Classes ----------------

/// A page widget that lists and manages the user's incoming push notifications and alerts.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

// ---------------- Build Method ----------------
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
              return const NotificationEmptyState();
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
                return NotificationItem(notification: notification);
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
}
