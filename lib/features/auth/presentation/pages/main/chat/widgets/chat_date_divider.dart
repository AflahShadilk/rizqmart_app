import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_date_widget.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class ChatDateDivider extends StatelessWidget {
  final DateTime timestamp;

  const ChatDateDivider({super.key, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.cs.outlineVariant.withValues(alpha: 0.5))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(timestamp),
              style: context.ts.labelSmall?.copyWith(
                color: context.cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Divider(color: context.cs.outlineVariant.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  /// Formats a DateTime into a smart date string (Today, Yesterday, or formatted date).
  String _formatDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (msgDate == today) {
      return 'Today';
    } else if (msgDate == yesterday) {
      return 'Yesterday';
    } else {
      return AppDateWidget.format(timestamp);
    }
  }
}
