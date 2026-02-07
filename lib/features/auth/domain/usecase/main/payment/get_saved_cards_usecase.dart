import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/saved_card_repository.dart';

class GetSavedCardsUseCase {
  final SavedCardRepository repository;

  GetSavedCardsUseCase(this.repository);

  Future<List<SavedCardEntity>> call(String userId) async {
    return await repository.getSavedCards(userId);
  }
}
