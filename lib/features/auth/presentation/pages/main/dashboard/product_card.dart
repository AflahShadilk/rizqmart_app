// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/core/services/firestore_product/variant_det_getter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

class ProductCard extends StatefulWidget {
  final ProductEntities product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  late String productName;
  late String? productImage;
  late String variantName;
  late double variantMrp;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    productName = widget.product.name;
    productImage = getVariantImages(widget.product).firstOrNull;
    variantName = getVariantNames(widget.product).first;
    variantMrp = getVariantMrp(widget.product).first;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.id != widget.product.id) {
      productName = widget.product.name;
      productImage = getVariantImages(widget.product).firstOrNull;
      variantName = getVariantNames(widget.product).first;
      variantMrp = getVariantMrp(widget.product).first;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetailsPage(product: widget.product))),
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
                    ProductImage(imageUrl: productImage),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                          fontSize: 17,
                                        ),
                                  ),
                                ),
                                Text(
                                  variantName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.onSurface,
                                          fontSize: 11,
                                        ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '₹${variantMrp.toStringAsFixed(0)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 1,
                                            color: context.cs.onSecondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                                  child: AddToCartButton(widget: widget.product),
                                )
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
