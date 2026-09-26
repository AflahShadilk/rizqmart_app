import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/pages/main/product_details/widgets/review_card.dart';
import 'package:rizqmart/features/presentation/pages/main/product_details/widgets/add_review_dialog.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';


/// A page displaying all customer reviews for a specific product, with options to add or edit user reviews.
class ReviewsPage extends StatefulWidget {
  final String productId;
  final String productName;

  const ReviewsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(GetReviewsEvent(productId: widget.productId));
  }

  void _showAddReviewDialog({ReviewEntity? existingReview}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AddReviewDialog(
          productId: widget.productId,
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userImage: user.photoURL,
          existingReview: existingReview,
          onSubmit: (review) {
            this.context.read<ReviewBloc>().add(AddReviewEvent(review: review));
          },
        ),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to add a review')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BackButtonCommon(colorScheme: Theme.of(context).colorScheme)),
        title: Text('Reviews', style: context.ts.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewsWithPurchaseStatus && state.hasPurchased) {
            final isEdit = state.existingReview != null;
            return FloatingActionButton.extended(
              onPressed: () => _showAddReviewDialog(
                existingReview: state.existingReview,
              ),
              label: Text(isEdit ? 'Edit Your Review' : 'Write a Review'),
              icon: Icon(isEdit ? Icons.edit : Icons.rate_review),
              backgroundColor: context.cs.primary,
              foregroundColor: context.cs.onPrimary,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text(state.message));
          } else if (state is ReviewsWithPurchaseStatus) {
            if (state.reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 64, color: context.cs.outline),
                    16.h,
                    Text('No reviews yet', style: context.ts.titleMedium),
                    8.h,
                    Text(
                      state.hasPurchased
                          ? 'Be the first to review this product!'
                          : 'No reviews yet for this product.',
                      style: context.ts.bodyMedium,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final review = state.reviews[index];
                return ReviewCard(review: review);
              },
            );
          } else if (state is ReviewsLoaded) {
            if (state.reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 64, color: context.cs.outline),
                    16.h,
                    Text('No reviews yet', style: context.ts.titleMedium),
                    8.h,
                    Text('No reviews yet for this product.',
                        style: context.ts.bodyMedium),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final review = state.reviews[index];
                return ReviewCard(review: review);
              },
            );
          }
          return const SizedBox();
        },
      ),
    ));
  }
}