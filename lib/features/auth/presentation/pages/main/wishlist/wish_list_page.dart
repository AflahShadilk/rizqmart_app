

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/widgets/wishlist_empty_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/widgets/wishlist_product_grid.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
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
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  16.h,
                  Text('Error: ${state.message}'),
                  16.h,
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
              return const WishlistEmptyState();
            }

            return WishlistProductGrid(allProducts: allProducts);
          }

          return const WishlistEmptyState();
        },
      ),
    ));
  }
}