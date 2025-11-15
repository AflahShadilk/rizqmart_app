// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
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

            return _buildFavoriteGrid(context, []);
          }

      
          return buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildFavoriteGrid(BuildContext context, List<dynamic> favoriteProducts) {
    if (favoriteProducts.isEmpty) {
      return buildEmptyState(context);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return _buildProductCard(context, product, index);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    dynamic product,
    int index,
  ) {
    // Extract product data - adjust based on your WishListEntities structure
    final productId = product.id ?? '';
    final productName = product.name ?? 'Product';
    final productImage = product.variantDetails?.isNotEmpty == true
        ? product.variantDetails![0]['imageUrls']:'';
    final productPrice = product.variantDetails?.isNotEmpty == true
        ? product.variantDetails![0]['mrp'] ?? 0
        : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: productImage.isNotEmpty
                        ? Image.network(
                            productImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image_not_supported),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                  ),
                  // Remove button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Send delete event to bloc
                        context.read<WishListBloc>().add(
                          DeleteWishListEvent(productId),
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$productName removed from favorites'),
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
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${productPrice.toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}