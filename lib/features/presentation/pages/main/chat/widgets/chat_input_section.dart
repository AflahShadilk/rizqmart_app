import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

/// Input section for composing and sending a new chat message.
class ChatInputSection extends StatelessWidget {

  // ---------------- Variables ----------------

  final TextEditingController messageController;
  final VoidCallback onSend;

  const ChatInputSection({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          // ---------------- Message Text Field ----------------
          Expanded(
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          8.w,
          // ---------------- Send Button ----------------
          IconButton(
            onPressed: onSend,
            icon: Icon(Icons.send_rounded, color: context.cs.primary),
            style: IconButton.styleFrom(
              backgroundColor: context.cs.primary.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
