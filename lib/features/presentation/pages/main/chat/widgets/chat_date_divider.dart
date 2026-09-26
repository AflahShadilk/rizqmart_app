import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

/// A centered date divider displayed between messages from different days.
class ChatDateDivider extends StatelessWidget {

  // ---------------- Variables ----------------

  final DateTime timestamp;

  const ChatDateDivider({super.key, required this.timestamp});

  // ---------------- Build Method ----------------

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

  // ---------------- Helper Methods ----------------

  /// Formats a DateTime into a readable date/time string.
  String _formatDate(DateTime timestamp) {
    return DateFormat('MMMM dd, yyyy • hh:mm a').format(timestamp);
  }
}
