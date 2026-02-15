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

      final reviewRef = firestore
          .collection('products')
          .doc(review.productId)
          .collection('reviews')
          .doc(); // Auto-ID

      await reviewRef.set(reviewModel.toFirestore());

      final productRef =
          firestore.collection('products').doc(review.productId);
          
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

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ReviewEntity>> getReviews(
      String productId) async {
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
}
