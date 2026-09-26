import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/review_repository.dart';

/// Use case for submitting a new customer review and rating for a product.
class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  Future<Either<Failure, void>> call(ReviewEntity review) async {
    return await repository.addReview(review);
  }
}
