import 'package:flutter/material.dart';
class ImageNotSupportIcon extends StatelessWidget {
final ColorScheme colorScheme;
  final double? size;
const ImageNotSupportIcon({
    super.key,
    required this.colorScheme,
    this.size,
  });
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
