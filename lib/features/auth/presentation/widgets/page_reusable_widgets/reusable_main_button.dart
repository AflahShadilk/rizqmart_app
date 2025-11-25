import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPress;
  final Color color;
  final Color textColor;

  const MainButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPress,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress,
      icon: Icon(icon, size: 22, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
      ),
    );
  }
}
