import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';

/// Base abstract class representing the possible states for the saved cards feature.
abstract class SavedCardsState extends Equatable {
  const SavedCardsState();

  @override
  List<Object?> get props => [];
}

class SavedCardsInitial extends SavedCardsState {}

class SavedCardsLoading extends SavedCardsState {}

class SavedCardsLoaded extends SavedCardsState {
  final List<SavedCardEntity> cards;

  const SavedCardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class SavedCardsError extends SavedCardsState {
  final String message;

  const SavedCardsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SavedCardOperationSuccess extends SavedCardsState {
  final String message;

  const SavedCardOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
