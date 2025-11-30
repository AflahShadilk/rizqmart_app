// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/image_not_support_icon.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/image_place_holder.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.height = 110,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
        color: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.onSurface.withOpacity(0.1)
            : Colors.grey.shade100,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return RectangularShimmerPlaceholder(
                    height: height,
                    width: width,
                    borderRadius: 12,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: colorScheme.onSurface.withOpacity(0.4),
                          size: 24,
                        ),
                        if (height > 60) 
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Image unavailable',
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSurface.withOpacity(0.4),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              )
            : imageNotSupportIcon(colorScheme, 24),
      ),
    );
  }
}
