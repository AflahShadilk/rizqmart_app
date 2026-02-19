import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class GetUserReviewUseCase {
  final ReviewRepository repository;

  GetUserReviewUseCase({required this.repository});

  Future<ReviewEntity?> call(String userId, String productId) {
    return repository.getUserReviewForProduct(userId, productId);
  }
}
