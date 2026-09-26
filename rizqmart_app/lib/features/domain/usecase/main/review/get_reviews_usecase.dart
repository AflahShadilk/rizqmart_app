import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/review_repository.dart';

/// Use case for fetching all published customer reviews for a specific product.
class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase({required this.repository});

  Future<Either<Failure, List<ReviewEntity>>> call(String productId) async {
    return await repository.getReviews(productId);
  }
}
