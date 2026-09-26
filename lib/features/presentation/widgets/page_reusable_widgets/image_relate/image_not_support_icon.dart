import 'package:flutter/material.dart';

// ---------------- Image Not Supported Icon ----------------

/// Returns a centered 'image_not_supported' icon, typically used as a fallback for failed image loads.
class ImageNotSupportIcon extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final ColorScheme colorScheme;
  final double? size;

  // ---------------- Constructor ----------------

  const ImageNotSupportIcon({
    super.key,
    required this.colorScheme,
    this.size,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_not_supported,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
        size: size,
      ),
    );
  }
}