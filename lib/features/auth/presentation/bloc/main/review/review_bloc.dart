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
    final result = await addReviewUseCase(event.review);
    result.fold(
      (failure) => emit(ReviewError(message: failure.message)),
      (_) {
        emit(ReviewAddedSuccess());
        add(GetReviewsEvent(productId: event.review.productId));
      },
    );
  }

  Future<void> _onGetReviews(
    GetReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    final reviewsResult = await getReviewsUseCase(event.productId);
    
    await reviewsResult.fold(
      (failure) async => emit(ReviewError(message: failure.message)),
      (reviews) async {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final purchaseResult = await checkPurchaseUseCase(currentUser.uid, event.productId);
          final userReviewResult = await getUserReviewUseCase(currentUser.uid, event.productId);

          purchaseResult.fold(
            (failure) => emit(ReviewError(message: failure.message)),
            (hasPurchased) {
              userReviewResult.fold(
                (failure) => emit(ReviewError(message: failure.message)),
                (existingReview) {
                  emit(ReviewsWithPurchaseStatus(
                    reviews: reviews,
                    hasPurchased: hasPurchased,
                    existingReview: existingReview,
                  ));
                },
              );
            },
          );
        } else {
          emit(ReviewsWithPurchaseStatus(
            reviews: reviews,
            hasPurchased: false,
          ));
        }
      },
    );
  }
}
