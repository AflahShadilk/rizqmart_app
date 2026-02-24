import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/get_saved_cards_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_state.dart';


class PaymentSelectionCubit extends Cubit<PaymentSelectionState> {
  final GetSavedCardsUseCase? getSavedCardsUseCase;

  PaymentSelectionCubit({this.getSavedCardsUseCase}) : super(const PaymentSelectionState());

  Future<void> loadSavedCards(String userId) async {
    if (getSavedCardsUseCase == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      final result = await getSavedCardsUseCase!(userId);
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
        (cards) => emit(state.copyWith(isLoading: false, savedCards: cards)),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void selectPayment(String paymentMethod) {
    
    if (paymentMethod != 'saved_card') {
      emit(state.copyWith(
        selectedPayment: paymentMethod,
        selectedSavedCard: null, 
      ));
    } else {
       emit(state.copyWith(selectedPayment: paymentMethod));
    }
  }

  void selectSavedCard(SavedCardEntity card) {
    emit(state.copyWith(
      selectedPayment: 'saved_card',
      selectedSavedCard: card,
    ));
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