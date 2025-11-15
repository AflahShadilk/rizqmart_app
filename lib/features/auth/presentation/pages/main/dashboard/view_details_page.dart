// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/quantity_counter.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/variant_det_getter.dart';

import '../../../widgets/buttons/like_button.dart';

class ViewDetailsPage extends StatefulWidget {
  final ProductEntities product;

  const ViewDetailsPage({super.key, required this.product,});

  @override
  State<ViewDetailsPage> createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  int currentImageIndex = 0;
  int count = 1;
  bool isExpanded = false;
  double rating = 4.5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_)=>CounterCubit(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    child: getVariantImages(widget).isNotEmpty
                        ? Stack(
                            children: [
                              PageView.builder(
                                onPageChanged: (index) {
                                  setState(() => currentImageIndex = index);
                                },
                                itemCount: getVariantImages(widget).length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    getVariantImages(widget)[index],
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
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
                              if (getVariantImages(widget).length > 1)
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: getVariantImages(widget)
                                        .asMap()
                                        .entries
                                        .map((entry) {
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
                                          boxShadow:
                                              currentImageIndex == entry.key
                                                  ? [
                                                      BoxShadow(
                                                        color: colorScheme.primary
                                                            .withOpacity(0.5),
                                                        blurRadius: 8,
                                                        spreadRadius: 2,
                                                      )
                                                    ]
                                                  : [],
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
                  // Back
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
                  child: Container(
                    color: colorScheme.background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.product.name,
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
                              LikeButton(productId: widget.product.id, productName: widget.product.name, variantDetails: widget.product!.variantDetails??[])
                              
                            ],
                          ),
                        ),
      
                        // Variant
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${getVariantNames(widget).isNotEmpty? getVariantNames(widget) : 'N/A'}kg",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
      
                        // Quantity
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<CounterCubit,int>(builder: (context,state){
                              return  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildQuantityButton(colorScheme),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary.withOpacity(0.7),
                                        colorScheme.primary.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary
                                            .withOpacity(0.4),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    "₹${(getVariantMrp(widget).first *state ).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                            })),
      
                        const SizedBox(height: 28),
      
                        // description
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
                                    widget.product.description ??
                                        "No description available",
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
      
                        // Reviews
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
              ),
            ],
          ),
        ),
      
        // Bottom Button
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
            child: BlocBuilder<CounterCubit,int>(builder: (contex,state){
              return ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    
                    content: Text("Added $state item(s) to cart"),
                    backgroundColor: colorScheme.primary,
                    duration: const Duration(milliseconds: 300),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined, size: 22),
              label: Text(
                "Add to Cart • ₹${(getVariantMrp(widget).first * state).toStringAsFixed(2)}",
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
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            );
            })
          )
        ),
      ),
    );
  }
}
