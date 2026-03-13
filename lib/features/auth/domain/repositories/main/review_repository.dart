import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
abstract class ReviewRepository {
  Future<Either<Failure, void>> addReview(ReviewEntity review);
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String productId);
  Future<Either<Failure, bool>> hasUserPurchasedProduct(String userId, String productId);
  Future<Either<Failure, ReviewEntity?>> getUserReviewForProduct(String userId, String productId);
}
