
import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(const ReviewInitial(5.0));

  void setRating(double rating) {
    emit(ReviewRatingUpdated(rating));
  }
}
