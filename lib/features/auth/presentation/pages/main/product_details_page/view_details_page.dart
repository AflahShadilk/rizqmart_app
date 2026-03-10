import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/firestore_product/access_product_variant_details.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';

import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:responsive_display/responsive_display.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/product/product_cart_check_cubit.dart';
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
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/review_card.dart';
import 'reviews_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_image_gallery.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_title_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_price_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_variant_selector.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_offers_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_description_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/product_review_section.dart';

/// A detail page showcasing product information, variants, pricing, reviews, and an option to add it to the cart.
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

  // ---------------- Variables ----------------

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
    return context.read<ProductCartCheckCubit>().getWishlistId(productId, variantIdx);
  }

  // ---------------- Init State ----------------

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

  // ---------------- Build Method ----------------

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
        BlocProvider(create: (_) => ProductCartCheckCubit()),
        BlocProvider(
            create: (_) =>
                sl<ReviewBloc>()..add(GetReviewsEvent(productId: productId))),
        BlocProvider(
            create: (_) =>
                sl<SingleProductBloc>()..add(GetSingleProductEvent(productId))),
      ],
      child: BlocBuilder<VariantSelectionCubit, int>(
        builder: (context, variantState) {
          selectedVariantIndex = variantState;
          final images = getImages(widget.product, selectedVariantIndex);
          final variantCount = getVariantDetails(widget.product).length;

          return ResponsiveWrapper(
              child: Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: ResponsiveLayoutBuilder(
                builder: (context, constraints, deviceType) {
                  bool isDesktop = deviceType == DeviceType.medium ||
                      deviceType == DeviceType.large ||
                      deviceType == DeviceType.xlarge;

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                       
                                    children: [
                                      BackButtonCommon(
                                          colorScheme: colorScheme),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.ios_share_outlined,
                                            color: context.cs.onSurface),
                                      ),
                                    ],
                                  ),
                                  20.h,
                                  SizedBox(
                                    height: 400,
                                    child: ProductImageGallery(
                                      images: images, 
                                      isDark: isDark, 
                                      colorScheme: colorScheme
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductTitleSection(
                                      product: widget.product, 
                                      selectedVariantIndex: selectedVariantIndex
                                  ),
                                  ProductPriceSection(
                                      product: widget.product, 
                                      selectedVariantIndex: selectedVariantIndex
                                  ),
                                  if (variantCount > 1)
                                    ProductVariantSelector(
                                        product: widget.product,
                                        count: variantCount,
                                        selectedIndex: selectedVariantIndex
                                    ),
                                  16.h,
                                  ProductOffersSection(productId: productId),
                                  28.h,
                                  ProductDescriptionSection(product: widget.product),
                                  30.h,
                                  ProductReviewSection(
                                      product: widget.product, 
                                      currentProductId: productId
                                  ),
                                  100.h,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
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
                                    ? colorScheme.onSurface
                                        .withValues(alpha: 0.1)
                                    : context.cs.onSurface
                                        .withValues(alpha: 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  )
                                ],
                              ),
                              child: ProductImageGallery(
                                  images: images, isDark: isDark, colorScheme: colorScheme,
                                  height: 280),
                            ),
                            Positioned(
                              top: 20,
                              left: 8,
                              child: Container(
                                margin: EdgeInsets.only(top: 20, left: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface
                                      .withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: BackButtonCommon(
                                    colorScheme: colorScheme),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 8,
                              child: Container(
                                margin: EdgeInsets.only(top: 20, right: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface
                                      .withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.ios_share_outlined,
                                      color: context.cs.onSurface,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 16, 20, 12),
                                  child: ProductTitleSection(
                                      product: widget.product, selectedVariantIndex: selectedVariantIndex),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child:
                                      ProductPriceSection(product: widget.product, selectedVariantIndex: selectedVariantIndex),
                                ),
                                if (variantCount > 1)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 24, 20, 16),
                                    child: ProductVariantSelector(
                                        product: widget.product,
                                        count: variantCount,
                                        selectedIndex: selectedVariantIndex),
                                  ),
                                16.h,
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ProductOffersSection(productId: productId),
                                ),
                                28.h,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ProductDescriptionSection(
                                      product: widget.product),
                                ),
                                30.h,
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 15, 0),
                                  child: ProductReviewSection(
                                      product: widget.product, currentProductId: productId,
                                      showList: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: BlocBuilder<ReviewBloc, ReviewState>(
                                    builder: (context, state) {
                                      List<ReviewEntity>? reviews;
                                      if (state is ReviewsWithPurchaseStatus) {
                                        reviews = state.reviews;
                                      } else if (state is ReviewsLoaded) {
                                        reviews = state.reviews;
                                      }
                                      if (reviews != null &&
                                          reviews.isNotEmpty) {
                                        final displayReviews =
                                            reviews.take(3).toList();
                                        return Column(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: displayReviews.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      Divider(height: 24),
                                              itemBuilder: (context, index) {
                                                return ReviewCard(
                                                    review:
                                                        displayReviews[index]);
                                              },
                                            ),
                                            if (reviews.length > 3)
                                              TextButton(
                                                onPressed: () {
                                                  final reviewBloc = context
                                                      .read<ReviewBloc>();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewsPage(
                                                        productId: productId,
                                                        productName: getName(
                                                            widget.product),
                                                      ),
                                                    ),
                                                  ).then((_) {
                                                    if (!mounted) return;
                                                    reviewBloc.add(
                                                        GetReviewsEvent(
                                                            productId:
                                                                productId));
                                                  });
                                                },
                                                child: Text(
                                                    'See All ${reviews.length} Reviews'),
                                              ),
                                          ],
                                        );
                                      } else if (state is ReviewLoading) {
                                        return Center(
                                            child: CircularProgressIndicator());
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
                color: context.cs.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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
                    double price =
                        getPrice(widget.product, selectedVariantIndex);
                    double discount = widget.product.discount ?? 0;
                    if (discount > 0) {
                      price = price - (price * discount / 100);
                    }
                    final totalPrice = (price * state).toStringAsFixed(2);

                    return BlocBuilder<CartBloc, CartState>(
                      builder: (context, cartState) {
                        // ignore: unused_local_variable
                        int currentCartCount = 0;
                        if (cartState is CartLoadedState) {
                          currentCartCount = cartState.items.fold(0, (previousValue, element) => previousValue + element.count);
                        }
                        
                        return MainButton(
                          label: 'Add to Cart $state Items  ₹$totalPrice',
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
    
                            final itemExists = context.read<ProductCartCheckCubit>().isItemInCart(
                              cartState,
                              productId,
                              selectedVariantIndex,
                            );
    
                            final variantName = getVariantName(
                              widget.product,
                              selectedVariantIndex,
                            );

                            if (!itemExists) {
                              final cartItem = CartEntities(
                                id: productId,
                                name: getName(widget.product),
                                brand: getBrand(widget.product),
                                description: getDescription(widget.product),
                                variantDetails: getVariantDetails(widget.product),
                                count: state,
                                variantIndex: selectedVariantIndex,
                                userId: '',
                                discount: widget.product.discount,
                              );
    
                              context.read<CartBloc>().add(
                                    AddToCartEvent(
                                      productId: productId,
                                      item: cartItem,
                                    ),
                                  );
                            } else {
                              if (cartState is CartLoadedState) {
                                final existingItem = cartState.items.firstWhere(
                                  (element) => element.id == productId && element.variantIndex == selectedVariantIndex,
                                );
                                
                                int newCount = existingItem.count + state;
                                if (newCount > 20) {
                                  newCount = 20;
                                }
                                
                                context.read<CartBloc>().add(
                                  UpdateQuantityEvent(
                                    cartItemId: '${productId}_variant_$selectedVariantIndex',
                                    count: newCount,
                                  ),
                                );
                                
                              }
                            }

                            showToast(
                              context,
                              "added '$state' '${getName(widget.product)}' '$variantName' to cart",
                              type: ToastType.success,
                            );
                            _showAddToCartAnimation(context);
                          },
                          color: context.cs.success,
                          textColor: ThemeCubit.textSecondaryDark,
                        );
                      }
                    );
                  },
                ),
              ),
            ),
          ));
        },
      ),
    );
  }

  void _showAddToCartAnimation(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.cs.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.cs.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Icon(
                Icons.shopping_cart_checkout_rounded,
                size: 60,
                color: context.cs.primary,
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  // ignore: unused_element
  bool _isItemInCart(
    dynamic cartState,
    String productId,
    int variantIndex,
  ) {
    return context.read<ProductCartCheckCubit>().isItemInCart(
      cartState,
      productId,
      variantIndex,
    );
  }


}
