import 'package:equatable/equatable.dart';

abstract class CookTonightEvent extends Equatable {
  const CookTonightEvent();

  @override
  List<Object?> get props => [];
}

class FetchIngredientsEvent extends CookTonightEvent {
  final String dishName;
  final int servings;

  const FetchIngredientsEvent({required this.dishName, required this.servings});

  @override
  List<Object?> get props => [dishName, servings];
}

class ResetCookTonightEvent extends CookTonightEvent {
  const ResetCookTonightEvent();
}
