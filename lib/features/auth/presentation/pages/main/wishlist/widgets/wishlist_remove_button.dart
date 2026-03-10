import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

// ---------------- Controllers & Classes ----------------

class WishlistRemoveButton extends StatelessWidget {
  
  // ---------------- Variables ----------------

  final WishListEntities wishListItem;

  const WishlistRemoveButton({
    super.key,
    required this.wishListItem,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          color: context.cs.onSurface.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.cs.onSecondary.withValues(alpha: 0.08),
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
    );
  }
}
