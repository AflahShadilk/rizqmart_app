import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/model/main/review_model.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/review_repository.dart';

/// Repository implementation handling product reviews, including purchase verification and rating calculation.
class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepositoryImpl({required this.firestore});

  @override
  Future<Either<Failure, void>> addReview(ReviewEntity review) {
    return ErrorHandler.executeApiCall(() async {
      // Server-side purchase verification
      final purchasedResult = await hasUserPurchasedProduct(review.userId, review.productId);
      
      bool purchased = false;
      purchasedResult.fold((f) => throw Exception(f.message), (v) => purchased = v);

      if (!purchased) {
        throw Exception('You must purchase this product before writing a review.');
      }

      final reviewModel = ReviewModel(
          id: review.id,
          productId: review.productId,
          userId: review.userId,
          userName: review.userName,
          userImage: review.userImage,
          rating: review.rating,
          comment: review.comment,
          createdAt: review.createdAt,
          variantName: review.variantName);

      // Check if user already has a review for this product
      final existingReviewResult = await getUserReviewForProduct(review.userId, review.productId);
      ReviewEntity? existingReview;
      existingReviewResult.fold((f) => throw Exception(f.message), (v) => existingReview = v);

      final productRef = firestore.collection('products').doc(review.productId);

      if (existingReview != null) {
        // UPDATE existing review
        final reviewRef = firestore
            .collection('products')
            .doc(review.productId)
            .collection('reviews')
            .doc(existingReview!.id);

        await reviewRef.update(reviewModel.toFirestore());

        // Adjust product rating: remove old rating and add new one
        await firestore.runTransaction((transaction) async {
          final productDoc = await transaction.get(productRef);
          if (!productDoc.exists) return;

          final data = productDoc.data() as Map<String, dynamic>;
          final currentRating = (data['rating'] ?? 0).toDouble();
          final currentCount = (data['reviewCount'] ?? 0) as int;

          if (currentCount > 0) {
            final newRating = ((currentRating * currentCount) - existingReview!.rating + review.rating) / currentCount;
            transaction.update(productRef, {'rating': newRating});
          }
        });
      } else {
        // CREATE new review
        final reviewRef = firestore
            .collection('products')
            .doc(review.productId)
            .collection('reviews')
            .doc();

        await reviewRef.set(reviewModel.toFirestore());

        await firestore.runTransaction((transaction) async {
          final productDoc = await transaction.get(productRef);

          if (!productDoc.exists) {
            return;
          }

          final data = productDoc.data() as Map<String, dynamic>;
          double currentRating = (data['rating'] ?? 0).toDouble();
          int currentCount = (data['reviewCount'] ?? 0);

          double newRating = ((currentRating * currentCount) + review.rating) / (currentCount + 1);

          transaction.update(productRef, {
            'rating': newRating,
            'reviewCount': currentCount + 1
          });
        });
      }
    });
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String productId) {
    return ErrorHandler.executeApiCall(() async {
      final snapshot = await firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
      return reviews;
    });
  }

  @override
  Future<Either<Failure, bool>> hasUserPurchasedProduct(String userId, String productId) {
    return ErrorHandler.executeApiCall(() async {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String? ?? '';
        if (status == 'cancelled') continue;

        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final itemMap = item as Map<String, dynamic>;
          if (itemMap['id'] == productId) {
            return true;
          }
        }
      }
      return false;
    });
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getUserReviewForProduct(String userId, String productId) {
    return ErrorHandler.executeApiCall(() async {
      final snapshot = await firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ReviewModel.fromFirestore(snapshot.docs.first);
    });
  }
}

