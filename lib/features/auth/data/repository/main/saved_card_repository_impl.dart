import 'package:rizqmart/features/auth/data/data_source/payment/saved_card_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/saved_card_repository.dart';

class SavedCardRepositoryImpl implements SavedCardRepository {
  final SavedCardRemoteDataSource dataSource;

  SavedCardRepositoryImpl(this.dataSource);

  @override
  Future<void> addSavedCard(SavedCardEntity card, String userId) async {
    await dataSource.addSavedCard(card, userId);
  }

  @override
  Future<List<SavedCardEntity>> getSavedCards(String userId) async {
    return await dataSource.getSavedCards(userId);
  }

  @override
  Future<void> deleteSavedCard(String cardId, String userId) async {
    await dataSource.deleteSavedCard(cardId, userId);
  }
}
