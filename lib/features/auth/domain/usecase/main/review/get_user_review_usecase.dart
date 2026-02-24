import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class GetUserReviewUseCase {
  final ReviewRepository repository;

  GetUserReviewUseCase({required this.repository});

  Future<Either<Failure, ReviewEntity?>> call(String userId, String productId) async {
    return await repository.getUserReviewForProduct(userId, productId);
  }
}
