import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/review_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepositoryImpl({required this.firestore});

  @override
  Future<void> addReview(ReviewEntity review) async {
    try {
      // Server-side purchase verification
      final purchased = await hasUserPurchasedProduct(review.userId, review.productId);
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
      final existingReview = await getUserReviewForProduct(review.userId, review.productId);

      final productRef = firestore.collection('products').doc(review.productId);

      if (existingReview != null) {
        // UPDATE existing review
        final reviewRef = firestore
            .collection('products')
            .doc(review.productId)
            .collection('reviews')
            .doc(existingReview.id);

        await reviewRef.update(reviewModel.toFirestore());

        // Adjust product rating: remove old rating and add new one
        await firestore.runTransaction((transaction) async {
          final productDoc = await transaction.get(productRef);
          if (!productDoc.exists) return;

          final data = productDoc.data() as Map<String, dynamic>;
          final currentRating = (data['rating'] ?? 0).toDouble();
          final currentCount = (data['reviewCount'] ?? 0) as int;

          if (currentCount > 0) {
            final newRating = ((currentRating * currentCount) - existingReview.rating + review.rating) / currentCount;
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    try {
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> hasUserPurchasedProduct(String userId, String productId) async {
    try {
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ReviewEntity?> getUserReviewForProduct(String userId, String productId) async {
    try {
      final snapshot = await firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ReviewModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

