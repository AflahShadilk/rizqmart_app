import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_empty_state.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_item.dart';

// ---------------- Controllers & Classes ----------------

/// A page widget that lists and manages the user's incoming push notifications and alerts.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        // "Clear All" tappable text action — behavior unchanged
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
              style: GoogleFonts.manrope(
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          8.w,
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }
          if (state is NotificationLoadedState) {
            if (state.notifications.isEmpty) {
              return const NotificationEmptyState();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.notifications.length,
              // Thin divider using design system dividerGray
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.dividerGray,
                indent: 16,
                endIndent: 16,
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
                style: GoogleFonts.manrope(
                  color: AppColors.statusCancelled,
                  fontSize: 14,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
