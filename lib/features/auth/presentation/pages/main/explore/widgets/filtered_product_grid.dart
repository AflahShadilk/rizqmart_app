import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/variant_card_reusable.dart';

class FilteredProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredVariants;

  const FilteredProductGrid({super.key, required this.filteredVariants});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredVariants.length,
      itemBuilder: (context, index) {
        ExploreEntities product = filteredVariants[index]['product'];
        int variantIndex = filteredVariants[index]['variantIndex'];
        Map<String, dynamic> variant = product.variantDetails[variantIndex];

        List<String> imageList = List<String>.from(variant['imageUrls'] ?? []);
        String image = imageList.isNotEmpty ? imageList[0] : '';
        String unitName = variant['unitName'] ?? '';

        double price = (variant['mrp'] ?? 0).toDouble();

        return VariantCard(
          productName: product.name,
          variantName: unitName,
          price: price,
          imageUrl: image,
          colorScheme: context.cs,
          actionButton: AddToCartButton(
            widget: product,
            variantIndex: variantIndex,
            count: 1,
          ),
          onTap: () {
            Navigator.pushNamed(
              context, 
              AppRoutes.productDetails,
              arguments: {
                'product': product,
                'variantIndex': variantIndex,
              }
            );
          },
        );
      },
    );
  }
}
