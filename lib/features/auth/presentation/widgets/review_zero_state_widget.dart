import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
class ReviewZeroStateWidget extends StatelessWidget {
  final VoidCallback? onWriteReview;

  const ReviewZeroStateWidget({super.key, this.onWriteReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withAlpha(40),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cs.outlineVariant.withAlpha(60),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning500.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              size: 32,
              color: AppColors.warning500,
            ),
          ),
          const SizedBox(height: 16),

          // Headline
          Text(
            'No reviews yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Be the first to review this product ⭐',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),

          // Write a Review button
          if (onWriteReview != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onWriteReview,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(
                  'Write a Review',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.cs.primary,
                  side: BorderSide(color: context.cs.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
