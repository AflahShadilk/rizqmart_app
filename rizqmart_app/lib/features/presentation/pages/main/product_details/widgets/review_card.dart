import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';

/// A card widget displaying an individual user's rating, comment, and profile details for a product review.
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: review.userImage != null
                  ? NetworkImage(review.userImage!)
                  : null,
              child: review.userImage == null
                  ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U')
                  : null,
            ),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.userName, style: context.ts.titleSmall),
                  4.h,
                  Text(
                    DateFormat.yMMMd().format(review.createdAt),
                    style: context.ts.bodySmall
                        ?.copyWith(color: context.cs.outline),
                  ),
                ],
              ),
            ),
            RatingBarIndicator(
              rating: review.rating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 16.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
        12.h,
        if (review.variantName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Variant: ${review.variantName}',
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        Text(
          review.comment,
          style: context.ts.bodyMedium,
        ),
      ],
    );
  }
}
