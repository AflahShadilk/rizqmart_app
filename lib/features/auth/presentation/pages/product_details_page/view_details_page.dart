// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/quantity_counter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
import '../../widgets/buttons/like_button.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;
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
  int currentImageIndex = 0;
  bool isExpanded = false;
  double rating = 4.5;

  String _getName() {
    if (widget.product is ProductEntities) {
      return (widget.product as ProductEntities).name;
    } else if (widget.product is ExploreEntities) {
      return (widget.product as ExploreEntities).name;
    } else if (widget.product is WishListEntities) {
      return (widget.product as WishListEntities).name;
    }
    return 'Product';
  }

  String _getDescription() {
    if (widget.product is ProductEntities) {
      return (widget.product as ProductEntities).description ??
          'No description available';
    }
    return 'No description available';
  }

  String getBrand() {
    if (widget.product is ProductEntities) {
      return (widget.product as ProductEntities).brand;
    } else if (widget.product is ExploreEntities) {
      return (widget.product as ExploreEntities).brand;
    }
    return 'Brand';
  }

  String _getId() {
    if (widget.product is ProductEntities) {
      return (widget.product as ProductEntities).id;
    } else if (widget.product is ExploreEntities) {
      return (widget.product as ExploreEntities).id;
    } else if (widget.product is WishListEntities) {
      return (widget.product as WishListEntities).id;
    }
    return '';
  }

  List<Map<String, dynamic>> _getVariantDetails() {
    if (widget.product is ProductEntities) {
      return (widget.product as ProductEntities).variantDetails ?? [];
    } else if (widget.product is ExploreEntities) {
      return (widget.product as ExploreEntities).variantDetails;
    } else if (widget.product is WishListEntities) {
      return (widget.product as WishListEntities).variantDetails;
    }
    return [];
  }

  List<String> _getImages() {
    final variants = _getVariantDetails();
    if (variants.isEmpty || widget.variantIndex >= variants.length) return [];

    final images = variants[widget.variantIndex]['imageUrls'] as List?;
    if (images == null) return [];

    return List<String>.from(images);
  }

  double _getPrice() {
    final variants = _getVariantDetails();
    if (variants.isEmpty || widget.variantIndex >= variants.length) return 0.0;

    final price = variants[widget.variantIndex]['mrp'] ?? 0;
    return (price is num) ? price.toDouble() : 0.0;
  }

  String _getVariantName() {
    final variants = _getVariantDetails();
    if (variants.isEmpty || widget.variantIndex >= variants.length) return '';

    final unitName = variants[widget.variantIndex]['unitName'] ?? '';
    // final unitType = variants[widget.variantIndex]['unitType'] ?? '';
    return '$unitName';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final images = _getImages();

    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Scaffold(
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
                          : Colors.grey.shade100,
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
                                  setState(() => currentImageIndex = index);
                                },
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    images[index],
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            colorScheme.primary,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.3),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              if (images.length > 1)
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        images.asMap().entries.map((entry) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: currentImageIndex == entry.key
                                            ? 28
                                            : 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentImageIndex == entry.key
                                              ? colorScheme.primary
                                              : colorScheme.onSurface
                                                  .withOpacity(0.2),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 20,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_outlined,
                            color: colorScheme.primary, size: 20),
                      ),
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
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getName(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            LikeButton(
                              productId: _getId(),
                              productName: _getName(),
                              variantDetails: _getVariantDetails(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getVariantName(),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<CounterCubit, int>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildQuantityButton(colorScheme),
                               
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary.withOpacity(0.7),
                                        colorScheme.primary.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "₹${(_getPrice() * state).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () =>
                                  setState(() => isExpanded = !isExpanded),
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
                                    duration: const Duration(milliseconds: 250),
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
                                  _getDescription(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.75),
                                    height: 1.6,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 250),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Rating",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onBackground,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      ...List.generate(5, (index) {
                                        return Icon(
                                          index < rating.floor()
                                              ? Icons.star_rounded
                                              : index < rating
                                                  ? Icons.star_half_rounded
                                                  : Icons.star_outline_rounded,
                                          color: Colors.amber,
                                          size: 18,
                                        );
                                      }),
                                      const SizedBox(width: 8),
                                      Text(
                                        "$rating",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onBackground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Add Review",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                return ElevatedButton.icon(
                  onPressed: () {
                    showToast(context, "Added $state item(s) to cart");
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, size: 22),
                  label: Text(
                    "Add to Cart • ₹${(_getPrice() * state).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                    shadowColor: colorScheme.primary.withOpacity(0.4),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
