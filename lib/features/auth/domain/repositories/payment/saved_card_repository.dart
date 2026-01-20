import 'package:rizqmart/features/auth/domain/entities/payment/saved_card_entity.dart';

abstract class SavedCardRepository {
  Future<void> addSavedCard(SavedCardEntity card, String userId);
  Future<List<SavedCardEntity>> getSavedCards(String userId);
  Future<void> deleteSavedCard(String cardId, String userId);
}
