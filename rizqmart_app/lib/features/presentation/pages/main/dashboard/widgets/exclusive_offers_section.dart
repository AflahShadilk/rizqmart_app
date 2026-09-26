import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/coupon/coupon_state.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/auto_scrolling_coupon_list.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';

// ---------------- Exclusive Offers Section Widget ----------------

/// Section displaying exclusive promotional coupons in a horizontal scrolling list
class ExclusiveOffersSection extends StatelessWidget {
  const ExclusiveOffersSection({super.key});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppHeading('Exclusive Offers'),
            ],
          ),
        ),
        BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
          builder: (context, state) {
            if (state is AvailableCouponLoading) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is AvailableCouponLoaded) {
              if (state.coupons.isEmpty) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('No exclusive offers at the moment.')),
                );
              }
              return AutoScrollingCouponList(coupons: state.coupons);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
