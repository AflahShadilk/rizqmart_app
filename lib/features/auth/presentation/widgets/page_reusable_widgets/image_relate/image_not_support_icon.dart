import 'package:flutter/material.dart';

/// Returns a centered 'image_not_supported' icon, typically used as a fallback for failed image loads.
Center imageNotSupportIcon(ColorScheme colorScheme,double? size) {
    return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                                size: size,
                              ),
                            );
  }