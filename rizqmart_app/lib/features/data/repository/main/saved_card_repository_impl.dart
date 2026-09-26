import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/saved_card_data_source.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/saved_card_repository.dart';

/// Repository implementation managing a user's saved payment methods securely.
class SavedCardRepositoryImpl implements SavedCardRepository {
  final SavedCardRemoteDataSource dataSource;

  SavedCardRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> addSavedCard(SavedCardEntity card, String userId) {
    return ErrorHandler.executeApiCall(() async {
      await dataSource.addSavedCard(card, userId);
    });
  }

  @override
  Future<Either<Failure, List<SavedCardEntity>>> getSavedCards(String userId) {
    return ErrorHandler.executeApiCall(() async {
      return await dataSource.getSavedCards(userId);
    });
  }

  @override
  Future<Either<Failure, void>> deleteSavedCard(String cardId, String userId) {
    return ErrorHandler.executeApiCall(() async {
      await dataSource.deleteSavedCard(cardId, userId);
    });
  }
}
