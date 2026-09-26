import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/payment/add_money_state.dart';

/// Cubit verifying input amounts for wallet funding before executing the transaction.
class AddMoneyCubit extends Cubit<AddMoneyState> {
  AddMoneyCubit() : super(const AddMoneyState.initial());

  double? validateAndParseAmount(String text) {
    final amount = double.tryParse(text);
    if (amount != null && amount > 0) {
      emit(state.copyWith(isValid: true, errorMessage: null));
      return amount;
    }
    emit(state.copyWith(
      isValid: false,
      errorMessage: 'Please enter a valid amount',
    ));
    return null;
  }

  void reset() {
    emit(const AddMoneyState.initial());
  }
}
