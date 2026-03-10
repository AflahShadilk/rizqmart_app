import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/variant_card_reusable.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/widgets/wishlist_remove_button.dart';

// ---------------- Controllers & Classes ----------------

class WishlistProductGrid extends StatelessWidget {
  
  // ---------------- Variables ----------------

  final List<WishListEntities> allProducts;

  const WishlistProductGrid({
    super.key,
    required this.allProducts,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
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
                currentVariantIndex < wishListItem.variantDetails.length
            ? wishListItem.variantDetails[currentVariantIndex]
            : {};

        List<String> imageList = List<String>.from(variant['imageUrls'] ?? []);
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
            Navigator.pushNamed(
              context,
              AppRoutes.productDetails,
              arguments: {
                'product': wishListItem,
                'variantIndex': wishListItem.variantIndex,
              },
            );
          },
          actionButton: WishlistRemoveButton(wishListItem: wishListItem),
        );
      },
    );
  }
}
