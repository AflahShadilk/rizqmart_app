import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit()
      : super(
          const CheckoutState(
            deliveryMethod: null,
            deliveryAddress: null,
            paymentMethod: null,
            promoCode: null,
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

  void reset() {
    emit(
      const CheckoutState(
        deliveryMethod: null,
        deliveryAddress: null,
        paymentMethod: null,
        promoCode: null,
      ),
    );
  }
}
