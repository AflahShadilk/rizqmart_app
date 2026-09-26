import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Dropdown Notification Empty State Widget ----------------

/// Widget displaying a minimal placeholder in the dropdown when there are no new notifications.
class DropdownNotificationEmptyState extends StatelessWidget {
  const DropdownNotificationEmptyState({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded, 
                size: 26, 
                color: context.cs.outline.withValues(alpha: 0.7),
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
}
