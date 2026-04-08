

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
// ---------------- Variant Card ----------------

/// A card widget displaying a specific product variant, complete with its name, image, price, and selection state.
class VariantCard extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final String productName;
  final String variantName;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;
  final Widget? actionButton; 
  final bool isSelected; 
  final ColorScheme colorScheme;

  // ---------------- Constructor ----------------

  const VariantCard({
    super.key,
    required this.productName,
    required this.variantName,
    required this.price,
    required this.imageUrl,
    required this.onTap,
    required this.colorScheme,
    this.actionButton,
    this.isSelected = false,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.onSecondary.withValues(alpha: 0.1),
              blurRadius: isSelected ? 10 : 6,
              spreadRadius: isSelected ? 2 : 0,
            )
          ],
        ),
        child: Card(
          elevation: isSelected ? 0 : 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: isSelected
              ? colorScheme.warning.withValues(alpha: 0.08)
              : context.cs.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             ProductImage(
                imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                height: 100,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        productName,
                        style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold,
                          fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.h,
                    
                      Text(
                        variantName,
                        style: context.ts.bodySmall?.copyWith(
                          fontSize: 11,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${price.toInt()}',
                            style: context.ts.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.success,
                            ),
                          ),
                          if (actionButton != null) actionButton!,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}