import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/presentation/cubits/checkout/checkout_state.dart';

/// Cubit managing all choices made throughout the multi-step checkout procedure.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit()
      : super(
          const CheckoutState(
            deliveryMethod: null,
            deliveryAddress: null,
            paymentMethod: null,
            promoCode: null,
            appliedCoupon: null,
          ),
        );

  void setDeliveryMethod(String method) {
    emit(state.copyWith(deliveryMethod: method));
  }

  void setDeliveryAddress(String address) {
    emit(state.copyWith(deliveryAddress: address));
  }

  void setPaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  void setPromoCode(String? code) {
    emit(state.copyWith(promoCode: code));
  }

  void setAppliedCoupon(CouponEntity? coupon) {
    emit(state.copyWith(appliedCoupon: coupon, promoCode: coupon?.name));
  }

  void setDeliveryNotes(String notes) {
    emit(state.copyWith(deliveryNotes: notes));
  }
  void reset() {
    emit(
      const CheckoutState(
        deliveryMethod: null,
        deliveryAddress: null,
        paymentMethod: null,
        promoCode: null,
        appliedCoupon: null,
      ),
    );
  }
}
