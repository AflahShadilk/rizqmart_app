import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';
class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  Future<Either<Failure, void>> call(ReviewEntity review) async {
    return await repository.addReview(review);
  }
}
