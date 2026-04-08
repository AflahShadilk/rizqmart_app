part of 'review_bloc.dart';

/// Base abstract class for triggering review submissions and queries.
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class AddReviewEvent extends ReviewEvent {
  final ReviewEntity review;

  const AddReviewEvent({required this.review});

  @override
  List<Object> get props => [review];
}

class GetReviewsEvent extends ReviewEvent {
  final String productId;

  const GetReviewsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class CheckPurchaseStatusEvent extends ReviewEvent {
  final String userId;
  final String productId;

  const CheckPurchaseStatusEvent({
    required this.userId,
    required this.productId,
  });

  @override
  List<Object> get props => [userId, productId];
}
