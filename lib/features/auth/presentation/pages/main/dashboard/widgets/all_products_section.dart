import 'package:flutter/material.dart';
import 'package:responsive_display/responsive_display.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/product_card.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/see_all_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';

// ---------------- All Products Section Widget ----------------

/// Section displaying all available products in a responsive grid layout
class AllProductsSection extends StatelessWidget {
  final List<ProductEntities> products;

  const AllProductsSection({
    super.key,
    required this.products,
  });

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppHeading('Products'),
              ReusableSeeAllButton(
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.allProduct,
                    arguments: products,
                  );
                },
              ),
            ],
          ),
        ),
        ResponsiveGrid(
          xsmallColumns: 2,
          smallColumns: 2,
          mediumColumns: 3,
          largeColumns: 4,
          xlargeColumns: 4,
          gap: 12,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: List.generate(
            products.length,
            (index) => ProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          ),
        ),
      ],
    );
  }
}
