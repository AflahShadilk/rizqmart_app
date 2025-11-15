// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/empty_wish_list.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<WishListBloc>().add(GetAllWishListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<WishListBloc, WishListState>(
        builder: (context, state) {
          if (state is LoadingWishListState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FailureWishListState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WishListBloc>().add(GetAllWishListEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is LoadedWishListState) {
            // ✅ FIXED: Now state.items is already a List<WishListEntities>
            final allProducts = state.items;

            if (allProducts.isEmpty) {
              return buildEmptyState(context);
            }

            // Build list of all variants from all products
            List<Map<String, dynamic>> allVariants = [];

            for (var product in allProducts) {
              if (product.variantDetails.isEmpty) {
                continue;
              }

              for (int i = 0; i < product.variantDetails.length; i++) {
                allVariants.add({
                  'product': product,
                  'variantIndex': i,
                });
              }
            }

            if (allVariants.isEmpty) {
              return buildEmptyState(context);
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: allVariants.length,
              itemBuilder: (context, index) {
                final product = allVariants[index]['product'];
                final variantIndex = allVariants[index]['variantIndex'];
                final variant = product.variantDetails[variantIndex];

                List<String> imageList =
                    List<String>.from(variant['imageUrls'] ?? []);
                String image = imageList.isNotEmpty ? imageList[0] : '';
                String unitName = variant['unitName'] ?? '';
                String unitType = variant['unitType'] ?? '';
                double price = (variant['mrp'] ?? 0).toDouble();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(
                          product: product,
                          variantIndex: variantIndex,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: image.isNotEmpty
                                  ? Image.network(
                                      image,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          height: 100,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 100,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                            ),
                            // Remove button
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<WishListBloc>().add(
                                        DeleteWishListEvent(product.id),
                                      );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.name} removed from favorites',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Product Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$unitName $unitType',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹${price.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${product.name} added to cart!',
                                              ),
                                              backgroundColor: Colors.green,
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
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
                  ),
                );
              },
            );
          }

          return buildEmptyState(context);
        },
      ),
    );
  }
}