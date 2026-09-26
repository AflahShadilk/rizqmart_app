
import 'package:equatable/equatable.dart';

/// Base abstract class containing the current star rating given by the user.
abstract class ReviewState extends Equatable {
  final double rating;
  const ReviewState(this.rating);

  @override
  List<Object> get props => [rating];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial(super.rating);
}

class ReviewRatingUpdated extends ReviewState {
  const ReviewRatingUpdated(super.rating);
}
