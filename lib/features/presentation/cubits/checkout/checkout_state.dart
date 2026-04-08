import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';

class CheckoutState extends Equatable {
  final String? deliveryMethod;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? promoCode;
  final CouponEntity? appliedCoupon;
  final String? userPhone;      
  final String? deliveryNotes;

  const CheckoutState({
    required this.deliveryMethod,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.promoCode,
    this.appliedCoupon,
    this.userPhone,
    this.deliveryNotes
  });

  CheckoutState copyWith({
    String? deliveryMethod,
    String? deliveryAddress,
    String? paymentMethod,
    String? promoCode,
    CouponEntity? appliedCoupon,
    String? deliveryNotes
  }) {
    return CheckoutState(
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }

  @override
  List<Object?> get props =>
      [deliveryMethod, deliveryAddress, paymentMethod, promoCode, appliedCoupon, deliveryNotes];
}