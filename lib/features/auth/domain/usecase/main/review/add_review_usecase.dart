import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  Future<void> call(ReviewEntity review) {
    return repository.addReview(review);
  }
}
