import 'package:equatable/equatable.dart';

class CheckoutCalculationState extends Equatable {
  final double totalMrp;
  final double subtotal;
  final double totalSavings;
  final double deliveryFee;
  final double couponDiscount;
  final double totalCost;
  final String? couponId;
  final String? couponName;

  const CheckoutCalculationState({
    required this.totalMrp,
    required this.subtotal,
    required this.totalSavings,
    required this.deliveryFee,
    required this.couponDiscount,
    required this.totalCost,
    this.couponId,
    this.couponName,
  });

  const CheckoutCalculationState.initial()
      : totalMrp = 0.0,
        subtotal = 0.0,
        totalSavings = 0.0,
        deliveryFee = 0.0,
        couponDiscount = 0.0,
        totalCost = 0.0,
        couponId = null,
        couponName = null;

  @override
  List<Object?> get props => [
        totalMrp,
        subtotal,
        totalSavings,
        deliveryFee,
        couponDiscount,
        totalCost,
        couponId,
        couponName,
      ];
}
