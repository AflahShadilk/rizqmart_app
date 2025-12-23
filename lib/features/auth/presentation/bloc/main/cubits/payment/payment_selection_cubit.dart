import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_state.dart';

class PaymentSelectionCubit extends Cubit<PaymentSelectionState> {
  PaymentSelectionCubit() : super(const PaymentSelectionState());

  void selectPayment(String paymentMethod) {
    emit(state.copyWith(selectedPayment: paymentMethod));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setError(String? errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }

  String getSelectedPayment() => state.selectedPayment;

  bool canProceed() => state.selectedPayment.isNotEmpty;
}