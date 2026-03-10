import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/product/review_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/product/review_state.dart';

/// A dialog widget that allows users to submit a new rating and comment or edit their existing review for a product.
class AddReviewDialog extends StatelessWidget {
  final String productId;
  final String userId;
  final String userName;
  final String? userImage;
  final String? variantName;
  final ReviewEntity? existingReview;
  final Function(ReviewEntity) onSubmit;

  const AddReviewDialog({
    super.key,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImage,
    this.variantName,
    this.existingReview,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewCubit()
        ..setRating(existingReview?.rating ?? 5.0),
      child: _AddReviewDialogBody(
        productId: productId,
        userId: userId,
        userName: userName,
        userImage: userImage,
        variantName: variantName,
        existingReview: existingReview,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _AddReviewDialogBody extends StatefulWidget {
  final String productId;
  final String userId;
  final String userName;
  final String? userImage;
  final String? variantName;
  final ReviewEntity? existingReview;
  final Function(ReviewEntity) onSubmit;

  const _AddReviewDialogBody({
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImage,
    this.variantName,
    this.existingReview,
    required this.onSubmit,
  });

  @override
  State<_AddReviewDialogBody> createState() => _AddReviewDialogBodyState();
}

class _AddReviewDialogBodyState extends State<_AddReviewDialogBody> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _commentController.text = widget.existingReview!.comment;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReview != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Your Review' : 'Rate Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                return RatingBar.builder(
                  initialRating: state.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    context.read<ReviewCubit>().setRating(rating);
                  },
                );
              },
            ),
            20.h,
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final String comment = _commentController.text.trim();
            if (comment.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please write a review comment')),
              );
              return;
            }
            final double rating = context.read<ReviewCubit>().state.rating;
            final review = ReviewEntity(
              id: widget.existingReview?.id ?? '',
              productId: widget.productId,
              userId: widget.userId,
              userName: widget.userName,
              userImage: widget.userImage,
              rating: rating,
              comment: comment,
              createdAt: DateTime.now(),
              variantName: widget.variantName,
            );
            widget.onSubmit(review);
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'Update' : 'Submit'),
        ),
      ],
    );
  }
}