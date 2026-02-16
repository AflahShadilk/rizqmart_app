import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/add_review_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/get_reviews_usecase.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUseCase addReviewUseCase;
  final GetReviewsUseCase getReviewsUseCase;

  ReviewBloc({
    required this.addReviewUseCase,
    required this.getReviewsUseCase,
  }) : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
    on<GetReviewsEvent>(_onGetReviews);
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      await addReviewUseCase(event.review);
      emit(ReviewAddedSuccess());
      
      add(GetReviewsEvent(productId: event.review.productId));
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }

  Future<void> _onGetReviews(
    GetReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(event.productId);
      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }
}
