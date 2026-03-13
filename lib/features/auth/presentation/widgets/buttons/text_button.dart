import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class AuthTextButton extends StatelessWidget {
final VoidCallback? onPress;
  final String content;
  final Color color;
const AuthTextButton({
    super.key,
    required this.onPress,
    required this.content,
    required this.color,
  });
@override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        content,
        style: context.ts.bodyMedium?.copyWith(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
