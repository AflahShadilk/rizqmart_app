// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/variant_det_getter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/add_to_cart_button.dart';

class ProductCard extends StatefulWidget {
  final ProductEntities product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewDetailsPage(product: widget.product))),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 140,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onBackground.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? colorScheme.onSurface.withOpacity(0.1)
                            : Colors.grey.shade100,
                        child: getVariantImages(widget).isNotEmpty
                            ? Image.network(
                                getVariantImages(widget).first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color:
                                          colorScheme.onSurface.withOpacity(0.4),
                                      size: 24,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: colorScheme.onSurface.withOpacity(0.4),
                                  size: 24,
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '₹${getVariantMrp(widget).first.toStringAsFixed(0)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color:Colors.green[800],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                AddToCartButton(widget: widget.product)
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
          ),
        ),
      ),
    );
  }
}