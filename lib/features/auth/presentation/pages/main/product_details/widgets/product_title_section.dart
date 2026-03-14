import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/like_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/core/services/firestore_product/access_product_variant_details.dart';

class ProductTitleSection extends StatelessWidget {
  final ShowProductEntities product;
  final int selectedVariantIndex;

  const ProductTitleSection({
    super.key,
    required this.product,
    required this.selectedVariantIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getBrand(product),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.cs.primary,
                ),
              ),
              4.h,
              Text(
                getName(product),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              8.h,
              // review summary under product title
              if (product.reviewCount == 0)
                Row(
                  children: [
                    Icon(Icons.star_outline_rounded, color: AppColors.warning500.withValues(alpha: 0.6), size: 18),
                    6.w,
                    Text(
                      'Be the first to review this product ⭐',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning500, size: 20),
                    4.w,
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    4.w,
                    Text(
                      '(${product.reviewCount} reviews)',
                      style: GoogleFonts.poppins(
                        color: context.cs.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        LikeButton(
          productId: product.id,
          productName: product.name,
          brand: product.brand,
          variantDetails: product.variantDetails,
          selectedVariantIndex: selectedVariantIndex,
        ),
      ],
    );
  }
}
