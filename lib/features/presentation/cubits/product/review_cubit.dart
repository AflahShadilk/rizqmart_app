
import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_state.dart';

/// Cubit regulating input state for product ratings up to five stars.
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(const ReviewInitial(5.0));

  void setRating(double rating) {
    emit(ReviewRatingUpdated(rating));
  }
}
