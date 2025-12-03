// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/empty_wish_list.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/variant_card_reusable.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishListBloc>().add(GetAllWishListEvent());
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: AppHeading('My Favorites'),
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
                  Icon(Icons.error, size: 50, color: context.cs.error),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WishListBloc>().add(
                            GetAllWishListEvent(),
                          );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is LoadedWishListState) {
            final allProducts = state.items;

            if (allProducts.isEmpty) {
              return buildEmptyState(context);
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
              ),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final wishListItem = allProducts[index];
                final currentVariantIndex = wishListItem.variantIndex;

                final variant = wishListItem.variantDetails.isNotEmpty &&
                        currentVariantIndex <
                            wishListItem.variantDetails.length
                    ? wishListItem.variantDetails[currentVariantIndex]
                    : {};

                List<String> imageList =
                    List<String>.from(variant['imageUrls'] ?? []);
                String image = imageList.isNotEmpty ? imageList[0] : '';
                double price = (variant['mrp'] ?? 0).toDouble();
                String unitName = variant['unitName'] ?? '';

                return VariantCard(
                  productName: wishListItem.name,
                  variantName: unitName,
                  price: price,
                  imageUrl: image,
                  colorScheme: Theme.of(context).colorScheme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: wishListItem,
                          variantIndex: wishListItem.variantIndex,
                        ),
                      ),
                    );
                  },
                  actionButton: GestureDetector(
                    onTap: () {
                      context.read<WishListBloc>().add(
                            DeleteWishListEvent(wishListItem.id),
                          );

                      showToast(
                        context,
                        '${wishListItem.name} removed from favorites',
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.cs.onBackground.withOpacity(0.08),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.cs.onSecondary.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.favorite,
                        color: context.cs.error,
                        size: 18,
                      ),
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
