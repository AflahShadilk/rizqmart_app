part of 'review_bloc.dart';

/// Base abstract class documenting whether reviews are loaded, loading, or errored.
abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewAddedSuccess extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  const ReviewsLoaded({required this.reviews});

  @override
  List<Object?> get props => [reviews];
}

class ReviewsWithPurchaseStatus extends ReviewState {
  final List<ReviewEntity> reviews;
  final bool hasPurchased;
  final ReviewEntity? existingReview;

  const ReviewsWithPurchaseStatus({
    required this.reviews,
    required this.hasPurchased,
    this.existingReview,
  });

  @override
  List<Object?> get props => [reviews, hasPurchased, existingReview];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}
