import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';

abstract class ReviewRepository {
  Future<void> addReview(ReviewEntity review);
  Future<List<ReviewEntity>> getReviews(String productId);
}
