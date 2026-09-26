import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/review_repository.dart';

/// Use case for retrieving a specific user's previously submitted review for a product.
class GetUserReviewUseCase {
  final ReviewRepository repository;

  GetUserReviewUseCase({required this.repository});

  Future<Either<Failure, ReviewEntity?>> call(String userId, String productId) async {
    return await repository.getUserReviewForProduct(userId, productId);
  }
}
