import 'package:flutter/material.dart';

Center imageNotSupportIcon(ColorScheme colorScheme,double? size) {
    return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                                size: size,
                              ),
                            );
  }