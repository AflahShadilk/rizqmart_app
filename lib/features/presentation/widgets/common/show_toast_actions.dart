import 'package:flutter/material.dart';

// ---------------- Toast Action ----------------

/// A global utility function to display a temporary, non-blocking toast notification across the screen via OverlayEntry.
void showToast(
  BuildContext context,
  String message, {
  ToastType type = ToastType.info,
}) {
  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 80,
      left: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _toastColor(type),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(milliseconds: 1200)).then((_) {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

// ---------------- Toast Types & Colors ----------------

enum ToastType {
  success,
  error,
  warning,
  info,
}

Color _toastColor(ToastType type) {
  // Toast colors are typically globally defined distinct primitives
  // regardless of surface theme to convey critical state clearly.
  switch (type) {
    case ToastType.success:
      return const Color(0xFF4CAF50); // Green
    case ToastType.error:
      return const Color(0xFFE53935); // Red
    case ToastType.warning:
      return const Color(0xFFFFB300); // Amber
    case ToastType.info:
      return const Color(0xFF2196F3); // Blue
  }
}
