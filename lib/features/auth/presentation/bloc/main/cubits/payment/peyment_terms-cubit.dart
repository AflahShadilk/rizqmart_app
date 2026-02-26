// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_terms_state.dart';

/// Cubit observing if the user has accepted or rejected the overall payment terms.
class PaymentTermsCubit extends Cubit<PaymentTermsState> {
  PaymentTermsCubit() : super(const PaymentTermsState());

  void toggleTerms(bool value) {
    emit(state.copyWith(termsAccepted: value));
  }

  void acceptTerms() {
    emit(state.copyWith(termsAccepted: true));
  }

  void rejectTerms() {
    emit(state.copyWith(termsAccepted: false));
  }

  bool isTermsAccepted() => state.termsAccepted;
}