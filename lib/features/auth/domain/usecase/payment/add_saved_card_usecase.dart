import 'package:rizqmart/features/auth/domain/entities/payment/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/payment/saved_card_repository.dart';

class AddSavedCardUseCase {
  final SavedCardRepository repository;

  AddSavedCardUseCase(this.repository);

  Future<void> call(SavedCardEntity card, String userId) async {
    return await repository.addSavedCard(card, userId);
  }
}
