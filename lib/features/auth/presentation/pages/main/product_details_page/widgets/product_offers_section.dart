import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class ProductOffersSection extends StatelessWidget {
  final String productId;

  const ProductOffersSection({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
      builder: (context, state) {
        if (state is AvailableCouponLoaded) {
          final applicableCoupons = state.coupons
              .where((c) => c.applicableProductIds.isEmpty || c.applicableProductIds.contains(productId))
              .toList();

          if (applicableCoupons.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Offers',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                12.h,
                ...applicableCoupons.map((coupon) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning500.withValues(alpha: 0.05),
                      border: Border.all(color: AppColors.warning500.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_offer, color: AppColors.warning500, size: 20),
                        12.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${coupon.percentage.toStringAsFixed(0)}% OFF',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warning500,
                                ),
                              ),
                              2.h,
                              Text(
                                coupon.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              2.h,
                              Text(
                                'Use coupon code during checkout (Min order ₹${coupon.minOrderValue.toStringAsFixed(0)})',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
