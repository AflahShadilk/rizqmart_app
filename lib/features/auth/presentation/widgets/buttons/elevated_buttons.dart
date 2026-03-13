import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class CustomElevatedButton extends StatelessWidget {
final double fontSize;
  final VoidCallback? onPress;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final String content;
const CustomElevatedButton({
    super.key,
    required this.fontSize,
    required this.onPress,
    required this.color,
    required this.padding,
    required this.content,
  });
@override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
      child: Text(
        content,
        style: context.ts.bodyLarge?.copyWith(
          fontSize: fontSize * 0.85,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
