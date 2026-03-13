import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/saved_card_repository.dart';
class AddSavedCardUseCase {
  final SavedCardRepository repository;

  AddSavedCardUseCase(this.repository);

  Future<Either<Failure, void>> call(SavedCardEntity card, String userId) async {
    return await repository.addSavedCard(card, userId);
  }
}
