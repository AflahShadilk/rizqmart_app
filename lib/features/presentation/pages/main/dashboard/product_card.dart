

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/utils/product/variant_det_getter.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_state.dart';



/// A reusable card widget to display a single product's summary, image, and price within grid layouts.
/// Sizes itself flexibly from the parent — no hardcoded width or height.
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
  // Number of distinct variants — used to decide whether to show "From ₹X"
  late int variantCount;

  late double discount;
  late bool hasDiscount;
  late double discountedPrice;

  // Shared border radius for card and image corners
  static const double _radius = 16;

  @override
  bool get wantKeepAlive => true;

// ---------------- Init State ----------------
  @override
  void initState() {
    super.initState();

    _initializeProductDetails();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _initializeProductDetails() {
    productName = widget.product.name;
    productImage = getVariantImages(widget.product).firstOrNull;

    final allNames = getVariantNames(widget.product);
    final allMrps = getVariantMrp(widget.product);

    variantCount = allNames.length;
    variantName = allNames.firstOrNull ?? '';
    variantMrp = allMrps.firstOrNull ?? 0.0;

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

    // Price label: "From ₹X" for multi-variant products, "₹X" for single-variant
    final priceLabel = variantCount > 1
        ? 'From ₹${discountedPrice.toStringAsFixed(0)}'
        : '₹${discountedPrice.toStringAsFixed(0)}';

    // Gesture detector handles the press animation and navigation to detail screen.
    // No hardcoded width/height — the card sizes to whatever the parent provides.
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: _onTapNav,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image fills top ~60% with rounded top corners already handled by parent ClipRRect
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductImage(
                        imageUrl: productImage,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(_radius),
                          topRight: Radius.circular(_radius),
                        ),
                      ),
                      // Discount badge top-left
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
                              style: GoogleFonts.manrope(
                                color: colorScheme.onError,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      // Coupon badge shown if a coupon exists but no direct discount
                      BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
                        builder: (context, state) {
                          if (state is AvailableCouponLoaded) {
                            final hasOffer = state.coupons.any(
                              (c) => c.applicableProductIds.isEmpty ||
                                  c.applicableProductIds.contains(widget.product.id),
                            );
                            if (hasOffer && !hasDiscount) {
                              return Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentAmber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Offer Inside!',
                                    style: GoogleFonts.manrope(
                                      color: AppColors.textPrimary,
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

                // Bottom ~40%: text info + add-to-cart button
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product name and variant/weight label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w600, // SemiBold
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                            if (variantName.isNotEmpty) ...[
                              2.h,
                              Text(
                                variantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Price row + circular add-to-cart button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Strikethrough MRP shown only when discounted
                                  if (hasDiscount) ...[
                                    Text(
                                      '₹${variantMrp.toStringAsFixed(0)}',
                                      style: GoogleFonts.manrope(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    2.h,
                                  ],
                                  // Final price — amber/orange bold as per design spec
                                  Text(
                                    priceLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.manrope(
                                      color: AppColors.accentAmber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // AddToCartButton — only the container color is overridden here;
                            // increment/decrement logic inside the widget is untouched.
                            Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme.of(context).colorScheme.copyWith(
                                  // The button internally uses success500 (green); we restyle to blue here
                                  primary: AppColors.primaryBlue,
                                ),
                              ),
                              child: _BlueCartButton(product: widget.product),
                            ),
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
    );
  }
}

/// A thin wrapper that renders the AddToCartButton with a blue circular container
/// instead of the default green — only the visual container is changed here.
class _BlueCartButton extends StatelessWidget {
  final ProductEntities product;

  const _BlueCartButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        shape: BoxShape.circle,
      ),
      child: AddToCartButton(widget: product),
    );
  }
}
