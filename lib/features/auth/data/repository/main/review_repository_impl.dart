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

      // 1. Add review to subcollection
      final reviewRef = firestore
          .collection('products')
          .doc(review.productId)
          .collection('reviews')
          .doc(); // Auto-ID

      // We need to save the model, but the model needs the ID if we want to store it inside.
      // Or we just store the data. The model toFirestore doesn't include ID usually for update,
      // but here we are creating.
      // Let's create a map to save.
      await reviewRef.set(reviewModel.toFirestore());

      // 2. Update product aggregation
      final productRef =
          firestore.collection('products').doc(review.productId);
          
      await firestore.runTransaction((transaction) async {
        final productDoc = await transaction.get(productRef);
        
        if (!productDoc.exists) {
           // If product doc doesn't exist, we can't update rating, but we shouldn't fail the review add.
           // Ideally we should create the product doc, but we might not have all data.
           // For now, let's just log or ignore the aggregation update to prevent crash.
           // print("Product document not found for aggregation update: ${review.productId}");
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

      // return const Right(null); // Removed standard return
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
