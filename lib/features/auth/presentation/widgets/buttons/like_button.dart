

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/likebutton/like_button_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

/// A heart icon button that toggles a product variant's presence in the user's wishlist.
class LikeButton extends StatefulWidget {
  final String productId;
  final String productName;
  final String? brand;
  final List<Map<String, dynamic>> variantDetails;
  final bool initialValue;
  final int selectedVariantIndex;

  const LikeButton({
    super.key,
    required this.productId,
    required this.productName,
    this.brand,
    required this.variantDetails,
    this.initialValue = false,
    this.selectedVariantIndex = 0
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  String get sanitizedProductId {
    if (widget.productId.contains('_variant_')) {
      return widget.productId.split('_variant_')[0];
    }
    return widget.productId;
  }

  String get getWishListItemId {
    return "${sanitizedProductId}_variant_${widget.selectedVariantIndex}";
  }
  
  String get getCurrentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => LikeButtonCubit(),
      child: BlocListener<WishListBloc, WishListState>(
        listener: (context, state) {
          if (state is FailureWishListState) {
            showToast(context, 'Error: ${state.message}');
          }
        },
        child: BlocBuilder<WishListBloc, WishListState>(
          builder: (context, wishlistState) {
            bool isFavorite = false;

            if (wishlistState is LoadedWishListState) {
              isFavorite = wishlistState.items
                  .any((item) => item.id == getWishListItemId);
            } else if (wishlistState is InitializeWishListState) {
              isFavorite = wishlistState.item
                  .any((item) => item.id == getWishListItemId);
            }
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFavorite
                      ? context.cs.error
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 28,
                ),
                onPressed: () {
                  _animationController.forward(from: 0.0);

                  List<Map<String, dynamic>> allVariants = widget.variantDetails;
                  String variantName = widget.variantDetails[widget.selectedVariantIndex]['unitName'] as String? ?? '';
                  context.read<WishListBloc>().add(
                    ToggleWishListEvent(
                      getWishListItemId,
                      '${widget.productName} - $variantName',
                      widget.brand ?? '',
                      allVariants,
                      widget.selectedVariantIndex,
                      getCurrentUserId
                    )
                  );
                  if (isFavorite) {
                    showToast(context, 'Removed from wishlist');
                  } else {
                    showToast(context, 'Added to wishlist');
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}