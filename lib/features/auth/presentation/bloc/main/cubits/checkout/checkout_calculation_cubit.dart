import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_calculation_state.dart';

class CheckoutCalculationCubit extends Cubit<CheckoutCalculationState> {
  CheckoutCalculationCubit() : super(const CheckoutCalculationState.initial());

  void calculate(CartLoadedState cartState) {
    double totalMrp = 0.0;
    for (var item in cartState.items) {
      if (item.variantDetails.isNotEmpty &&
          item.variantIndex < item.variantDetails.length) {
        final variant = item.variantDetails[item.variantIndex];
        final price = (variant['mrp'] ?? 0).toDouble();
        totalMrp += price * item.count;
      }
    }

    final subtotal = cartState.totalAmount;
    final totalSavings = totalMrp - subtotal;
    final deliveryFee = subtotal > 150 ? 0.0 : 40.0;
    final totalCost = subtotal + deliveryFee;

    emit(CheckoutCalculationState(
      totalMrp: totalMrp,
      subtotal: subtotal,
      totalSavings: totalSavings,
      deliveryFee: deliveryFee,
      totalCost: totalCost,
    ));
  }
}
