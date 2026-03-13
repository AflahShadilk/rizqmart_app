
import 'package:equatable/equatable.dart';
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
