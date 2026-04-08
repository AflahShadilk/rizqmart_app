

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/image_not_support_icon.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/image_place_holder.dart';

// ---------------- Product Image ----------------

/// A reusable image container that handles network caching, loading states, and error fallbacks.
class ProductImage extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final String? imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  // ---------------- Constructor ----------------

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.height = 110,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
        color: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.onSurface.withValues(alpha: 0.1)
            : Colors.grey.shade100,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                memCacheHeight: (height * 3).toInt(), 
                memCacheWidth: width != double.infinity ? (width * 3).toInt() : null,
                placeholder: (context, url) => RectangularShimmerPlaceholder(
                  height: height,
                  width: width,
                  borderRadius: 12,
                ),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 24,
                      ),
                      if (height > 60)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Image unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : ImageNotSupportIcon(colorScheme: colorScheme, size: 24),
      ),
    );
  }
}
