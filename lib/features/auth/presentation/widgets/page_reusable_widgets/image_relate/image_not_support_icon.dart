import 'package:flutter/material.dart';

Center imageNotSupportIcon(ColorScheme colorScheme,double? size) {
    return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                // ignore: deprecated_member_use
                                color: colorScheme.onSurface.withOpacity(0.4),
                                size: size,
                              ),
                            );
  }