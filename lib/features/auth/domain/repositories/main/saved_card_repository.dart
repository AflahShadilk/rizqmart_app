import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';

abstract class SavedCardRepository {
  Future<Either<Failure, void>> addSavedCard(SavedCardEntity card, String userId);
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards(String userId);
  Future<Either<Failure, void>> deleteSavedCard(String cardId, String userId);
}
