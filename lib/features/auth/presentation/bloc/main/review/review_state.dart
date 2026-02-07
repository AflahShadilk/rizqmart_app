part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewAddedSuccess extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  const ReviewsLoaded({required this.reviews});

  @override
  List<Object> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError({required this.message});

  @override
  List<Object> get props => [message];
}
