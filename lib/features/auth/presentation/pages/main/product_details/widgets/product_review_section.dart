import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details/reviews_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details/widgets/review_card.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/core/services/firestore_product/access_product_variant_details.dart';

class ProductReviewSection extends StatelessWidget {
  final ShowProductEntities product;
  final String currentProductId;
  final bool showList;

  const ProductReviewSection({
    super.key,
    required this.product,
    required this.currentProductId,
    this.showList = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!showList)
              TextButton(
                onPressed: () {
                  final reviewBloc = context.read<ReviewBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsPage(
                        productId: currentProductId,
                        productName: getName(product),
                      ),
                    ),
                  ).then((_) {
                    if (!context.mounted) return;
                    reviewBloc
                        .add(GetReviewsEvent(productId: currentProductId));
                  });
                },
                child: const Text('See All'),
              ),
          ],
        ),
        if (showList) ...[
          12.h,
          BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              List<ReviewEntity>? reviews;
              if (state is ReviewsWithPurchaseStatus) {
                reviews = state.reviews;
              } else if (state is ReviewsLoaded) {
                reviews = state.reviews;
              }
              if (reviews != null) {
                if (reviews.isEmpty) {
                  return Text(
                    "No reviews yet",
                    style: GoogleFonts.poppins(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => 16.h,
                  itemBuilder: (context, index) {
                    return ReviewCard(review: reviews![index]);
                  },
                );
              } else if (state is ReviewError) {
                return Text("Failed to load reviews: ${state.message}");
              }
              return const SizedBox();
            },
          ),
        ],
      ],
    );
  }
}
