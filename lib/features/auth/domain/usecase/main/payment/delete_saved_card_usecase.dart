import 'package:rizqmart/features/auth/domain/repositories/main/saved_card_repository.dart';

class DeleteSavedCardUseCase {
  final SavedCardRepository repository;

  DeleteSavedCardUseCase(this.repository);

  Future<void> call(String cardId, String userId) async {
    return await repository.deleteSavedCard(cardId, userId);
  }
}
