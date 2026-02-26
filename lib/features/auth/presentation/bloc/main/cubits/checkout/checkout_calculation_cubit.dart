import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_calculation_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_engine.dart';

/// Cubit evaluating cart totals, discounts, coupons, and delivery fees during checkout.
class CheckoutCalculationCubit extends Cubit<CheckoutCalculationState> {
  CheckoutCalculationCubit() : super(const CheckoutCalculationState.initial());

  void calculate(List<CartEntities> cartItems, {CouponEntity? coupon}) {
    final totalMrp = CouponEngine.calculateTotalMrp(cartItems);
    final subtotal = CouponEngine.calculateCartSubtotal(cartItems);
    final totalSavings = totalMrp - subtotal;
    final deliveryFee = subtotal > 150 ? 0.0 : 40.0;

    double couponDiscount = 0.0;
    String? couponId;
    String? couponName;

    if (coupon != null) {
      final result = CouponEngine.computeResult(coupon, cartItems, deliveryFee);
      if (result.isValid) {
        couponDiscount = result.discount;
        couponId = coupon.id;
        couponName = coupon.name;
      }
    }

    final totalCost = (subtotal - couponDiscount) + deliveryFee;

    emit(CheckoutCalculationState(
      totalMrp: totalMrp,
      subtotal: subtotal,
      totalSavings: totalSavings,
      deliveryFee: deliveryFee,
      couponDiscount: couponDiscount,
      totalCost: totalCost < 0 ? 0 : totalCost,
      couponId: couponId,
      couponName: couponName,
    ));
  }
}
