import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/review_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details_page/widgets/add_review_dialog.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';


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

  void _showAddReviewDialog() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AddReviewDialog(
          productId: widget.productId,
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userImage: user.photoURL,
          onSubmit: (review) {
            context.read<ReviewBloc>().add(AddReviewEvent(review: review));
          },
        ),
      );
    } else {
        
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please login to add a review')),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReviewDialog,
        label: Text('Write a Review'),
        icon: Icon(Icons.rate_review),
        backgroundColor: context.cs.primary,
        foregroundColor: context.cs.onPrimary,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text(state.message));
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
                    Text('Be the first to review this product!',
                        style: context.ts.bodyMedium),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.reviews.length,
              separatorBuilder: (context, index) => Divider(height: 32),
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