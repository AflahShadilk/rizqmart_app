// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/empty_wish_list.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/image_not_support_icon.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
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
                   Icon(Icons.error, size: 50, color:context.cs.error),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WishListBloc>().add(GetAllWishListEvent());
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
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
              ),
              itemCount: allVariants.length,
              itemBuilder: (context, index) {
                final product = allVariants[index]['product'];
                final variantIndex = allVariants[index]['variantIndex'];
                final variant = product.variantDetails[variantIndex];

                List<String> imageList = List<String>.from(variant['imageUrls'] ?? []);
                String image = imageList.isNotEmpty ? imageList[0] : '';
                double price = (variant['mrp'] ?? 0).toDouble();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product,
                          variantIndex: variantIndex,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: image.isNotEmpty
                                  ? Image.network(
                                      image,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 100,
                                          color: context.cs.onSurface,
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    )
                                  : imageNotSupportIcon(context.cs, 50),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<WishListBloc>().add(
                                    DeleteWishListEvent(product.id),
                                  );

                                  showToast(context, '${product.name} removed from favorites');
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
                                  child:  Icon(
                                    Icons.favorite,
                                    color: context.cs.error,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                            
                                
                                
                                Text(
                                  '₹${price.toInt()}',
                                  style:  TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: context.cs.success,
                                  ),
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