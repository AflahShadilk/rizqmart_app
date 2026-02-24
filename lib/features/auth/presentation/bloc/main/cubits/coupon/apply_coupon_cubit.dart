import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/apply_coupon_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_engine.dart';

class ApplyCouponCubit extends Cubit<ApplyCouponState> {
  ApplyCouponCubit() : super(const ApplyCouponState.initial());

  void applyCoupon(
    CouponEntity coupon,
    List<CartEntities> cartItems,
    double deliveryFee,
  ) {
    final result = CouponEngine.computeResult(coupon, cartItems, deliveryFee);

    if (!result.isValid) {
      emit(ApplyCouponState(
        appliedCoupon: null,
        discount: 0.0,
        error: result.error,
      ));
      return;
    }

    emit(ApplyCouponState(
      appliedCoupon: coupon,
      discount: result.discount,
      error: null,
    ));
  }

  void removeCoupon() {
    emit(const ApplyCouponState.initial());
  }

  void revalidate(List<CartEntities> cartItems, double deliveryFee) {
    if (state.appliedCoupon == null) return;

    final result =
        CouponEngine.computeResult(state.appliedCoupon!, cartItems, deliveryFee);

    if (!result.isValid) {
      emit(const ApplyCouponState.initial());
      return;
    }

    emit(ApplyCouponState(
      appliedCoupon: state.appliedCoupon,
      discount: result.discount,
      error: null,
    ));
  }
}
