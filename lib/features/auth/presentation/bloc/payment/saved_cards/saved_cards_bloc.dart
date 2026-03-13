import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/add_saved_card_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/delete_saved_card_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/get_saved_cards_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/payment/saved_cards/saved_cards_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/payment/saved_cards/saved_cards_state.dart';
class SavedCardsBloc extends Bloc<SavedCardsEvent, SavedCardsState> {
  final GetSavedCardsUseCase getSavedCardsUseCase;
  final AddSavedCardUseCase addSavedCardUseCase;
  final DeleteSavedCardUseCase deleteSavedCardUseCase;

  SavedCardsBloc({
    required this.getSavedCardsUseCase,
    required this.addSavedCardUseCase,
    required this.deleteSavedCardUseCase,
  }) : super(SavedCardsInitial()) {
    on<LoadSavedCardsEvent>(_onLoadSavedCards);
    on<AddSavedCardEvent>(_onAddSavedCard);
    on<DeleteSavedCardEvent>(_onDeleteSavedCard);
  }

  Future<void> _onLoadSavedCards(
      LoadSavedCardsEvent event, Emitter<SavedCardsState> emit) async {
    emit(SavedCardsLoading());
    try {
      final result = await getSavedCardsUseCase(event.userId);
      result.fold(
        (failure) => emit(SavedCardsError(failure.message)),
        (cards) => emit(SavedCardsLoaded(cards)),
      );
    } catch (e) {
      emit(SavedCardsError(e.toString()));
    }
  }

  Future<void> _onAddSavedCard(
      AddSavedCardEvent event, Emitter<SavedCardsState> emit) async {
    emit(SavedCardsLoading());
    try {
      final result = await addSavedCardUseCase(event.card, event.userId);
      result.fold(
        (failure) => emit(SavedCardsError(failure.message)),
        (_) {
          emit(const SavedCardOperationSuccess('Card added successfully'));
          add(LoadSavedCardsEvent(event.userId));
        },
      );
    } catch (e) {
      emit(SavedCardsError(e.toString()));
    }
  }

  Future<void> _onDeleteSavedCard(
      DeleteSavedCardEvent event, Emitter<SavedCardsState> emit) async {
    emit(SavedCardsLoading());
    try {
      final result = await deleteSavedCardUseCase(event.cardId, event.userId);
      result.fold(
        (failure) => emit(SavedCardsError(failure.message)),
        (_) {
          emit(const SavedCardOperationSuccess('Card removed successfully'));
          add(LoadSavedCardsEvent(event.userId));
        },
      );
    } catch (e) {
      emit(SavedCardsError(e.toString()));
    }
  }
}
