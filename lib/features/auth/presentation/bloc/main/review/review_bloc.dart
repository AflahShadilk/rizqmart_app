import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/add_review_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/check_purchase_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/get_reviews_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/review/get_user_review_usecase.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUseCase addReviewUseCase;
  final GetReviewsUseCase getReviewsUseCase;
  final CheckPurchaseUseCase checkPurchaseUseCase;
  final GetUserReviewUseCase getUserReviewUseCase;

  ReviewBloc({
    required this.addReviewUseCase,
    required this.getReviewsUseCase,
    required this.checkPurchaseUseCase,
    required this.getUserReviewUseCase,
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

      // Check purchase status for the current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final hasPurchased = await checkPurchaseUseCase(
          currentUser.uid,
          event.productId,
        );
        final existingReview = await getUserReviewUseCase(
          currentUser.uid,
          event.productId,
        );
        emit(ReviewsWithPurchaseStatus(
          reviews: reviews,
          hasPurchased: hasPurchased,
          existingReview: existingReview,
        ));
      } else {
        // Not logged in — can only view
        emit(ReviewsWithPurchaseStatus(
          reviews: reviews,
          hasPurchased: false,
        ));
      }
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }
}
