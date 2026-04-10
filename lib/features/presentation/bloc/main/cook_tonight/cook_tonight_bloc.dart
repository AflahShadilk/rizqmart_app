import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/domain/usecase/main/cook_tonight/get_ingredients_for_dish_usecase.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_state.dart';

class CookTonightBloc extends Bloc<CookTonightEvent, CookTonightState> {
  final GetIngredientsForDishUsecase _getIngredientsForDish;

  CookTonightBloc(this._getIngredientsForDish) : super(const CookTonightInitial()) {
    on<FetchIngredientsEvent>(_onFetchIngredients);
    on<ResetCookTonightEvent>(_onReset);
  }

  Future<void> _onFetchIngredients(
    FetchIngredientsEvent event,
    Emitter<CookTonightState> emit,
  ) async {
    emit(const CookTonightLoading());

    final result = await _getIngredientsForDish(
      dishName: event.dishName,
      servings: event.servings,
    );

    result.fold(
      (failure) => emit(CookTonightError(failure.message)),
      (data) => emit(CookTonightLoaded(data)),
    );
  }

  void _onReset(ResetCookTonightEvent event, Emitter<CookTonightState> emit) {
    emit(const CookTonightInitial());
  }
}
