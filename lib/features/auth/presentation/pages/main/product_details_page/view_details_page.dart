// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/services/firestore_product/access_product_variant_details.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';

import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:responsive_display/responsive_display.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/product/single_product_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/description/desicription_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/image/image_index_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/variantselection/variant_selection_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import '../../../widgets/buttons/like_button.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/review_card.dart';
import 'reviews_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final ShowProductEntities product;
  final int variantIndex;

  const ProductDetailsPage({
    super.key,
    required this.product,
    this.variantIndex = 0,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isExpanded = false;
  late int selectedVariantIndex;
  String get productId {
    final id = getId(widget.product);
    if (id.contains('_variant_')) {
      return id.split('_variant_')[0];
    }
    return id;
  }

  String getWishlistId(int variantIdx) {
    return '${productId}_variant_$variantIdx';
  }

  @override
  void initState() {
    super.initState();
    selectedVariantIndex = widget.variantIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlistState = context.read<WishListBloc>().state;
      if (wishlistState is! LoadedWishListState) {
        context.read<WishListBloc>().add(GetAllWishListEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(
          create: (_) =>
              VariantSelectionCubit()..selectVariant(widget.variantIndex),
        ),
        BlocProvider(create: (_) => ImageIndexCubit()),
        BlocProvider(create: (_) => DesicriptionCubit()),
        BlocProvider(create: (_) => sl<ReviewBloc>()..add(GetReviewsEvent(productId: productId))),
        BlocProvider(create: (_) => sl<SingleProductBloc>()..add(GetSingleProductEvent(productId))),
      ],
      child: BlocBuilder<VariantSelectionCubit, int>(
        builder: (context, variantState) {
          selectedVariantIndex = variantState;
          final images = getImages(widget.product, selectedVariantIndex);
          final variantCount = getVariantDetails(widget.product).length;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: ResponsiveLayoutBuilder(
                builder: (context, constraints, deviceType) {
                  // Check if we should use desktop layout (medium and above)
                  bool isDesktop = deviceType == DeviceType.medium || 
                                   deviceType == DeviceType.large ||
                                   deviceType == DeviceType.xlarge;

                  if (isDesktop) {
                    // Desktop Layout: Row with 2 columns
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Images (Expanded)
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                   // Back Button for Desktop
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BackButtonCommon(colorScheme: colorScheme),
                                       IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.ios_share_outlined, color: context.cs.onSecondary),
                                      ),
                                    ],
                                  ),
                                  20.h,
                                  // Image Stack (reused logic but adapted sizing)
                                  SizedBox(
                                    height: 400, // Taller image for desktop
                                    child: _buildImageStack(context, images, isDark, colorScheme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Right Column: Details (Expanded)
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title, Variant, Wishlist
                                  _buildTitleSection(context, selectedVariantIndex),
                                  
                                  // Price & Quantity
                                  _buildPriceSection(context, colorScheme),

                                  // Variants Grid
                                  if (variantCount > 1) _buildVariantsSection(context, variantCount, selectedVariantIndex, colorScheme),
                                  
                                  28.h,
                                  // Description
                                  _buildDescriptionSection(context, colorScheme),
                                  
                                  30.h,
                                  // Reviews
                                  _buildReviewSection(context, colorScheme, productId),
                                  
                                  100.h,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Mobile Layout (Original Column)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 280,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isDark
                                    ? colorScheme.onSurface.withOpacity(0.1)
                                    : context.cs.onSurface.withOpacity(0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                              child: _buildImageStack(context, images, isDark, colorScheme, height: 280),
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Positioned(
                                  top: 20,
                                  left: 8,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20, left: 8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: BackButtonCommon(colorScheme: colorScheme),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 8,
                                  child: Container(
                                     margin: EdgeInsets.only(top: 20, right: 8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.ios_share_outlined,
                                          color: context.cs.onSecondary,
                                          size: 20,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                                  child: _buildTitleSection(context, selectedVariantIndex),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: _buildPriceSection(context, colorScheme),
                                ),
                                if (variantCount > 1)
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 24, 20, 16),
                                    child: _buildVariantsSection(context, variantCount, selectedVariantIndex, colorScheme),
                                  ),
                                28.h,
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: _buildDescriptionSection(context, colorScheme),
                                ),
                                30.h,
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                  child: _buildReviewSection(context, colorScheme, productId, showList: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: BlocBuilder<ReviewBloc, ReviewState>(
                                    builder: (context, state) {
                                      if (state is ReviewsLoaded && state.reviews.isNotEmpty) {
                                        final displayReviews = state.reviews.take(3).toList();
                                        return Column(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: displayReviews.length,
                                              separatorBuilder: (context, index) => Divider(height: 24),
                                              itemBuilder: (context, index) {
                                                return ReviewCard(review: displayReviews[index]);
                                              },
                                            ),
                                            if (state.reviews.length > 3)
                                              TextButton(
                                                onPressed: () {
                                                  final reviewBloc = context.read<ReviewBloc>();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ReviewsPage(
                                                        productId: productId,
                                                        productName: getName(widget.product),
                                                      ),
                                                    ),
                                                  ).then((_) {
                                                     if(!mounted) return;
                                                     reviewBloc.add(GetReviewsEvent(productId: productId));
                                                  });
                                                },
                                                child: Text('See All ${state.reviews.length} Reviews'),
                                              ),
                                          ],
                                        );
                                      } else if (state is ReviewLoading) {
                                         return Center(child: CircularProgressIndicator());
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                               100.h, 
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            bottomSheet: Container(
              decoration: BoxDecoration(
                color: context.cs.surface.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: context.cs.onSecondary.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                child: BlocBuilder<CounterCubit, int>(
                  builder: (context, state) {
                     double price = getPrice(widget.product, selectedVariantIndex);
                     double discount = widget.product.discount ?? 0;
                     if(discount > 0) {
                        price = price - (price * discount / 100);
                     }
                    final totalPrice = (price * state).toStringAsFixed(2);
                    return MainButton(
                        label: 'Add to Cart ₹$totalPrice',
                        icon: Icons.shopping_bag_outlined,
                        onPress: () {
                          if (state < 1) {
                            showToast(
                              context,
                              'Please select at least 1 item',
                              type: ToastType.error,
                            );
                            return;
                          }
                          final cartItem = CartEntities(
                              id: productId,
                              name: getName(widget.product),
                              brand: getBrand(widget.product),
                              description: getDescription(widget.product),
                              variantDetails: getVariantDetails(widget.product),
                              count: state,
                              variantIndex: selectedVariantIndex,
                              userId: '',
                              discount: widget.product.discount);
                          context.read<CartBloc>().add(AddToCartEvent(
                              productId: productId, item: cartItem));
                          final variantName = getVariantName(
                              widget.product, selectedVariantIndex);
                          showToast(context,
                              'Added $state x ${getName(widget.product)} ($variantName) to cart!',
                              type: ToastType.success);
                        },
                        color: context.cs.success,
                        textColor: ThemeCubit.textSecondaryDark);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageStack(BuildContext context, List<String> images, bool isDark, ColorScheme colorScheme, {double? height}) {
    return Stack(
      children: [
        BlocBuilder<ImageIndexCubit, int>(
          builder: (context, state) {
            return PageView.builder(
              onPageChanged: (value) {
                context.read<ImageIndexCubit>().change(value);
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ProductImage(
                  imageUrl: images[index],
                  height: height ?? 350,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => BlocBuilder<ImageIndexCubit, int>(
                builder: (context, state) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: state == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: state == index
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, int index) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getBrand(widget.product),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.cs.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                getName(widget.product),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.product.rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${widget.product.reviewCount} reviews)',
                    style: GoogleFonts.poppins(
                      color: context.cs.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        LikeButton(
          productId: widget.product.id,
          productName: widget.product.name,
          brand: widget.product.brand,
          variantDetails: widget.product.variantDetails,
          selectedVariantIndex: index,
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, ColorScheme colorScheme) {
    double price = getPrice(widget.product, selectedVariantIndex);
    final discount = widget.product.discount;
    final hasDiscount = discount != null && discount > 0;
    
    double finalPrice = price;
    if (hasDiscount) {
      finalPrice = price - (price * discount! / 100);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${finalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 12),
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  decoration: TextDecoration.lineThrough,
                  decorationColor: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '-${discount!.toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildVariantsSection(
      BuildContext context, int count, int selectedIndex, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Variants',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(count, (index) {
            final isSelected = selectedIndex == index;
            final variantName = getVariantName(widget.product, index);
            return GestureDetector(
              onTap: () {
                context.read<VariantSelectionCubit>().selectVariant(index);
                context.read<ImageIndexCubit>().change(0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary.withOpacity(0.1) : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  variantName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ColorScheme colorScheme) {
    final description = getDescription(widget.product);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<DesicriptionCubit, bool>(
          builder: (context, isExpanded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (description.length > 100)
                  GestureDetector(
                    onTap: () {
                      context.read<DesicriptionCubit>().toggle();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        isExpanded ? 'Read Less' : 'Read More',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context, ColorScheme colorScheme, String currentProductId, {bool showList = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!showList)
              TextButton(
                onPressed: () {
                  final reviewBloc = context.read<ReviewBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsPage(
                        productId: currentProductId,
                        productName: getName(widget.product),
                      ),
                    ),
                  ).then((_) {
                      if (!mounted) return;
                      reviewBloc.add(GetReviewsEvent(productId: currentProductId));
                  });
                },
                child: Text('See All'),
              ),
          ],
        ),
        if (showList) ...[
          const SizedBox(height: 12),
           BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReviewsLoaded) {
                if (state.reviews.isEmpty) {
                  return Text(
                    "No reviews yet",
                    style: GoogleFonts.poppins(
                      color: context.cs.onSurface.withOpacity(0.6),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.reviews.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return ReviewCard(review: state.reviews[index]);
                  },
                );
              } else if (state is ReviewError) {
                return Text("Failed to load reviews: ${state.message}");
              }
              return const SizedBox();
            },
          ),
        ],
      ],
    );
  }
}
