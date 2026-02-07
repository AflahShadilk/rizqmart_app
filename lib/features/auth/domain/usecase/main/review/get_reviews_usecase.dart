import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase({required this.repository});

  Future<List<ReviewEntity>> call(String productId) {
    return repository.getReviews(productId);
  }
}
