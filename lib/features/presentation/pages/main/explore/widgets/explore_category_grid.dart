import 'package:flutter/material.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

class ExploreCategoryGrid extends StatelessWidget {
  final List<dynamic> categories;

  const ExploreCategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = isDark
            ? AppColors.exploreDarkCards[index % AppColors.exploreDarkCards.length]
            : AppColors.exploreLightCards[index % AppColors.exploreLightCards.length];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.productByCategory,
                arguments: cat.categoryName);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProductImage(
                    imageUrl: cat.logoUrl,
                    height: 60,
                    width: 80,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Text(
                  cat.categoryName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
