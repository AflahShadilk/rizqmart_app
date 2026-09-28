import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_event.dart';

// ---------------- Notification Dropdown Header Widget ----------------

/// Header widget for the notification dropdown — title left, "Clear all" blue text button right.
class NotificationDropdownHeader extends StatelessWidget {
  const NotificationDropdownHeader({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: GoogleFonts.manrope(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          // Plain blue text button — no background pill, no border
          TextButton(
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                context.read<NotificationBloc>().add(ClearAllNotificationsEvent(userId));
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Clear all',
              style: GoogleFonts.manrope(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
