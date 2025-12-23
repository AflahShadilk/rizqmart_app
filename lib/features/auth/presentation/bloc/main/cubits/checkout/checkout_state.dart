import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final String? deliveryMethod;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? promoCode;

  const CheckoutState({
    required this.deliveryMethod,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.promoCode,
  });

  CheckoutState copyWith({
    String? deliveryMethod,
    String? deliveryAddress,
    String? paymentMethod,
    String? promoCode,
  }) {
    return CheckoutState(
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  @override
  List<Object?> get props =>
      [deliveryMethod, deliveryAddress, paymentMethod, promoCode];
}