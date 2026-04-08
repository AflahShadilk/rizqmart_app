

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/utils/product/variant_det_getter.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_state.dart';



/// A reusable card widget to display a single product's summary, image, and price within grid layouts.
class ProductCard extends StatefulWidget {
  final ProductEntities product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
      
  // ---------------- Variables ----------------
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  late String productName;
  late String? productImage;
  late String variantName;
  late double variantMrp;

  late double discount;
  late bool hasDiscount;
  late double discountedPrice;

  static const double _radiusValue = 12;

  @override
  bool get wantKeepAlive => true;

// ---------------- Init State ----------------
  @override
  void initState() {
    super.initState();

    _initializeProductDetails();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _initializeProductDetails() {
    productName = widget.product.name;
    productImage = getVariantImages(widget.product).firstOrNull;
    variantName = getVariantNames(widget.product).first;
    variantMrp = getVariantMrp(widget.product).first;
    
    discount = widget.product.discount ?? 0;
    hasDiscount = discount > 0;
    discountedPrice = hasDiscount 
        ? variantMrp - (variantMrp * discount / 100) 
        : variantMrp;
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.id != widget.product.id) {
       _initializeProductDetails();
    }
  }

// ---------------- Dispose ----------------
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// ---------------- Navigation Methods ----------------
  void _onTapNav() {
    Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {
      'product': widget.product,
      'variantIndex': 0,
    });
  }

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colorScheme = Theme.of(context).colorScheme;

    // Gesture detector handles the press animation and navigation to detail screen
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: _onTapNav,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 140,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radiusValue),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radiusValue),
              child: Material(
                color: colorScheme.surface,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImage(imageUrl: productImage),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  // Product name and variant description section
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
                                              fontSize: 14,
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
                                    ),
                                  ],
                                ),
                                // Pricing and Add to Cart button section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hasDiscount) ...[
                                            Text(
                                              '₹${variantMrp.toStringAsFixed(0)}',
                                              style: GoogleFonts.inter(
                                                decoration: TextDecoration.lineThrough,
                                                color: context.cs.onSurface.withValues(alpha: 0.6),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            2.h,
                                          ],
                                          Text(
                                            '₹${discountedPrice.toStringAsFixed(0)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    letterSpacing: 0.5,
                                                    color: colorScheme.primary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 5, 5),
                                      child: AddToCartButton(
                                        widget: widget.product,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Discount badge showing percentage off if applicable
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${discount.toStringAsFixed(0)}% OFF',
                            style: GoogleFonts.inter(
                              color: colorScheme.onError,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      // Coupon badge shown if a coupon is available but no direct discount exists
                      BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
                        builder: (context, state) {
                          if (state is AvailableCouponLoaded) {
                            final hasOffer = state.coupons.any((c) => c.applicableProductIds.isEmpty || c.applicableProductIds.contains(widget.product.id));
                            if (hasOffer && !hasDiscount) {
                              return Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Offer Inside!',
                                    style: GoogleFonts.inter(
                                      color: colorScheme.onSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
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
