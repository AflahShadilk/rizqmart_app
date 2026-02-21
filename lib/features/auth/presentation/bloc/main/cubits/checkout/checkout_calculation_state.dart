import 'package:equatable/equatable.dart';

class CheckoutCalculationState extends Equatable {
  final double totalMrp;
  final double subtotal;
  final double totalSavings;
  final double deliveryFee;
  final double totalCost;

  const CheckoutCalculationState({
    required this.totalMrp,
    required this.subtotal,
    required this.totalSavings,
    required this.deliveryFee,
    required this.totalCost,
  });

  const CheckoutCalculationState.initial()
      : totalMrp = 0.0,
        subtotal = 0.0,
        totalSavings = 0.0,
        deliveryFee = 0.0,
        totalCost = 0.0;

  @override
  List<Object?> get props => [totalMrp, subtotal, totalSavings, deliveryFee, totalCost];
}
