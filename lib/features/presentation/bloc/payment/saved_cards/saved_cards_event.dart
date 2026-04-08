import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';

/// Base abstract class defining all intents related to saved payment card management.
abstract class SavedCardsEvent extends Equatable {
  const SavedCardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedCardsEvent extends SavedCardsEvent {
  final String userId;
  const LoadSavedCardsEvent(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class AddSavedCardEvent extends SavedCardsEvent {
  final SavedCardEntity card;
  final String userId;
  const AddSavedCardEvent(this.card, this.userId);

  @override
  List<Object?> get props => [card, userId];
}

class DeleteSavedCardEvent extends SavedCardsEvent {
  final String cardId;
  final String userId;
  const DeleteSavedCardEvent(this.cardId, this.userId);

  @override
  List<Object?> get props => [cardId, userId];
}
