import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';

/// Abstract repository for securely managing a user's saved payment methods.
abstract class SavedCardRepository {
  Future<Either<Failure, void>> addSavedCard(SavedCardEntity card, String userId);
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards(String userId);
  Future<Either<Failure, void>> deleteSavedCard(String cardId, String userId);
}
