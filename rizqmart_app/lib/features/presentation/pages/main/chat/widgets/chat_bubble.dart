

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

/// A stateless widget that renders an individual chat message bubble along with its timestamp.
class ChatBubble extends StatelessWidget {

  // ---------------- Variables ----------------

  final MessageEntity message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? context.cs.primary : context.cs.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: context.ts.bodyMedium?.copyWith(
                color: isMe ? context.cs.onPrimary : context.cs.onSurface,
              ),
            ),
            4.h,
            // Message date and time
            Text(
              DateFormat('MMM dd, yyyy • hh:mm a').format(message.timestamp),
              style: context.ts.bodySmall?.copyWith(
                color: isMe ? context.cs.onPrimary.withValues(alpha: 0.7) : context.cs.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}