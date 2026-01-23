// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/services/firestore_product/access_product_variant_details.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/description/desicription_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/image/image_index_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/variantselection/variant_selection_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/quantity_counter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/image_not_support_icon.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/variant_card_reusable.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import '../../widgets/buttons/like_button.dart';

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
  double rating = 4.5;
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
      ],
      child: BlocBuilder<VariantSelectionCubit, int>(
        builder: (context, variantState) {
          selectedVariantIndex = variantState;
          final images = getImages(widget.product, selectedVariantIndex);
          final variantCount = getVariantDetails(widget.product).length;

          return Scaffold(
            backgroundColor: colorScheme.background,
            body: SafeArea(
              child: Column(
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
                        child: images.isNotEmpty
                            ? Stack(
                                children: [
                                  PageView.builder(
                                    onPageChanged: (index) {
                                      context
                                          .read<ImageIndexCubit>()
                                          .change(index);
                                    },
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return ProductImage(
                                        imageUrl: images[index],
                                        height: 280,
                                        width: double.infinity,
                                        borderRadius: BorderRadius.circular(12),
                                      );
                                    },
                                  ),
                                  if (images.length > 1)
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: BlocBuilder<ImageIndexCubit, int>(
                                        builder: (context, currentImageIndex) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: images
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                width: currentImageIndex ==
                                                        entry.key
                                                    ? 28
                                                    : 8,
                                                height: 8,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: currentImageIndex ==
                                                          entry.key
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface
                                                          .withOpacity(0.2),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    )
                                ],
                              )
                            : imageNotSupportIcon(colorScheme, 50),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Positioned(
                            top: 20,
                            left: 8,
                            child: Container(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getName(
                                          widget.product,
                                        ),
                                        style: GoogleFonts.inter(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: context.cs.onSurface,
                                                fontSize: 24,
                                              ),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      6.h,
                                      Text(
                                          getVariantName(widget.product,
                                              selectedVariantIndex),
                                          style: GoogleFonts.inter(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: context.cs.onSurface,
                                                  fontSize: 15,
                                                ),
                                          )),
                                    ],
                                  ),
                                ),
                                12.w,
                                BlocBuilder<WishListBloc, WishListState>(
                                  builder: (context, state) {
                                    bool isInWishList = false;

                                    if (state is LoadedWishListState) {
                                      isInWishList = state.items.any((item) {
                                        final match = item.id ==
                                            getWishlistId(selectedVariantIndex);
                                        return match;
                                      });
                                    } else if (state
                                        is InitializeWishListState) {
                                      isInWishList = state.item.any((item) {
                                        final match = item.id ==
                                            getWishlistId(selectedVariantIndex);
                                        return match;
                                      });
                                    }

                                    return LikeButton(
                                        key: ValueKey(getWishlistId(
                                            selectedVariantIndex)),
                                        productId: productId,
                                        productName: getName(widget.product),
                                        variantDetails:
                                            getVariantDetails(widget.product),
                                        selectedVariantIndex:
                                            selectedVariantIndex,
                                        initialValue: isInWishList);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: BlocBuilder<CounterCubit, int>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    quantityButton(colorScheme),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 12),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if ((widget.product is ProductEntities) && ((widget.product as ProductEntities).discount ?? 0) > 0)
                                              Text(
                                                 "₹${(getPrice(widget.product, selectedVariantIndex) * state).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: context.cs.onSurface.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            Text(
                                              "₹${((getPrice(widget.product, selectedVariantIndex) - (getPrice(widget.product, selectedVariantIndex) * ((widget.product is ProductEntities ? (widget.product as ProductEntities).discount : 0) ?? 0) / 100)) * state).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: context.cs.onSecondary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (variantCount > 1)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 24, 20, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available variants',
                                    style: context.ts.bodyMedium!.copyWith(
                                        color: context.cs.onBackground,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  12.h,
                                  GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio: 0.85,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12),
                                      itemCount: variantCount,
                                      itemBuilder: (context, index) {
                                        final isSelected =
                                            selectedVariantIndex == index;
                                        return VariantCard(
                                            productName:
                                                getName(widget.product),
                                            variantName: getVariantName(
                                                widget.product, index),
                                            price:
                                                getPrice(widget.product, index),
                                            imageUrl: getImages(
                                                        widget.product, index)
                                                    .isNotEmpty
                                                ? getImages(
                                                    widget.product, index)[0]
                                                : '',
                                            onTap: () {
                                              context
                                                  .read<VariantSelectionCubit>()
                                                  .selectVariant(index);
                                              context
                                                  .read<CounterCubit>()
                                                  .reset();
                                              context
                                                  .read<ImageIndexCubit>()
                                                  .change(0);
                                            },
                                            isSelected: isSelected,
                                            colorScheme: colorScheme);
                                      })
                                ],
                              ),
                            ),
                          28.h,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<DesicriptionCubit, bool>(
                              builder: (context, isExpanded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () => context
                                          .read<DesicriptionCubit>()
                                          .toggle(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onBackground,
                                            ),
                                          ),
                                          AnimatedRotation(
                                            turns: isExpanded ? 0.5 : 0,
                                            duration: const Duration(
                                                milliseconds: 250),
                                            child: Icon(
                                              Icons.expand_more,
                                              color: colorScheme.primary,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedCrossFade(
                                      firstChild: const SizedBox.shrink(),
                                      secondChild: Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          getDescription(widget.product),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.75),
                                            height: 1.6,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                      crossFadeState: isExpanded
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration:
                                          const Duration(milliseconds: 250),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          30.h,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Review",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                                50.w,
                                ...List.generate(5, (index) {
                                  return Icon(
                                    index < rating.floor()
                                        ? Icons.star_rounded
                                        : index < rating
                                            ? Icons.star_half_rounded
                                            : Icons.star_outline_rounded,
                                    color: context.cs.secondary,
                                    size: 18,
                                  );
                                }),
                                Text(
                                  "$rating",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(10),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                            Icons.navigate_next_outlined))),
                              ],
                            ),
                          ),
                          100.h,
                        ],
                      ),
                    ),
                  ),
                ],
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
                     double discount = (widget.product is ProductEntities) ? ((widget.product as ProductEntities).discount ?? 0) : 0;
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
                              discount: (widget.product is ProductEntities)
                                  ? (widget.product as ProductEntities).discount
                                  : null);
                          context.read<CartBloc>().add(AddToCartEvent(
                              productId: productId, item: cartItem));
                          final variantName = getVariantName(
                              widget.product, selectedVariantIndex);
                          showToast(context,
                              'Added $count x ${getName(widget.product)} ($variantName) to cart!',
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
}
