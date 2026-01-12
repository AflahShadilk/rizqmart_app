import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final String? deliveryMethod;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? promoCode;
  final String? userPhone;      
  final String? deliveryNotes;

  const CheckoutState({
    required this.deliveryMethod,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.promoCode,
    this.userPhone,
    this.deliveryNotes
  });

  CheckoutState copyWith({
    String? deliveryMethod,
    String? deliveryAddress,
    String? paymentMethod,
    String? promoCode,
    String? deliveryNotes
  }) {
    return CheckoutState(
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }

  @override
  List<Object?> get props =>
      [deliveryMethod, deliveryAddress, paymentMethod, promoCode,deliveryNotes];
}