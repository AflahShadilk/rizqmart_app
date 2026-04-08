import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Notification Empty State Widget ----------------

/// Widget displaying a placeholder when there are no new notifications.
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
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
}
