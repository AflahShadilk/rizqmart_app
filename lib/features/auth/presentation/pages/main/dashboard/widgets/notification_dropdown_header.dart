import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';

// ---------------- Notification Dropdown Header Widget ----------------

/// Header widget for the notification dropdown, showing the title and a "Clear all" button.
class NotificationDropdownHeader extends StatelessWidget {
  const NotificationDropdownHeader({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.04),
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
                 context.read<NotificationBloc>().add(ClearAllNotificationsEvent(userId));
               }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Clear all', 
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
}
