// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class VariantCard extends StatelessWidget {
  final String productName;
  final String variantName;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;
  final Widget? actionButton; 
  final bool isSelected; 
  final ColorScheme colorScheme;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: colorScheme.primary.withOpacity(0.4),
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.onSecondary.withOpacity(0.1),
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
              ? colorScheme.warning.withOpacity(0.08)
              : context.cs.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: colorScheme.onSurface.withOpacity(0.05),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  colorScheme.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: colorScheme.onSurface.withOpacity(0.3),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        productName,
                        style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold,
                          fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    
                      Text(
                        variantName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                      const Spacer(),
                      // Price and Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${price.toInt()}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
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