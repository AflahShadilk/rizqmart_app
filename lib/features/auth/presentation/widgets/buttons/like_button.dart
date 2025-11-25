// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/likebutton/like_button_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class LikeButton extends StatefulWidget {
  final String productId;
  final String productName;
  final String? brand;
  final List<Map<String, dynamic>> variantDetails;
  final bool initialValue;

  const LikeButton({
    super.key,
    required this.productId,
    required this.productName,
    this.brand,
    required this.variantDetails,
    this.initialValue = false,
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => LikeButtonCubit(),
      child: BlocListener<WishListBloc, WishListState>(
        listener: (context, state) {
          final cubit = context.read<LikeButtonCubit>();
          if (state is FailureWishListState) {
            showToast(context, 'Error: ${state.message}');
            cubit.toggle();
          }
          else if (state is LoadedWishListState) {
            _animationController.forward(from: 0.0);
            bool isNowInWishlist = state.items.any((item) => item.id == widget.productId);
            if (isNowInWishlist) {
              showToast(context, 'Added to wishlist');
            } else {
              showToast(context, 'Removed from wishlist');
            }
          }
        },
        child: BlocBuilder<WishListBloc, WishListState>(
          builder: (context, wishlistState) {
            bool isFavorite = widget.initialValue;

            if (wishlistState is LoadedWishListState) {
              isFavorite = wishlistState.items
                  .any((item) => item.id == widget.productId);
            }
            else if (wishlistState is InitializeWishListState) {
              isFavorite = wishlistState.item
                  .any((item) => item.id == widget.productId);
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
                      : colorScheme.onSurface.withOpacity(0.6),
                  size: 28,
                ),
                onPressed: () {
                  context.read<LikeButtonCubit>().toggle();
                  _animationController.forward(from: 0.0);
                  context.read<WishListBloc>().add(
                    ToggleWishListEvent(
                      widget.productId,
                      widget.productName,
                      widget.brand ?? '',
                      widget.variantDetails,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}