import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rizqmart/features/auth/domain/entities/main/review_entity.dart';


class AddReviewDialog extends StatefulWidget {
  final String productId;
  final String userId;
  final String userName;
  final String? userImage;
  final String? variantName;
  final Function(ReviewEntity) onSubmit;

  const AddReviewDialog({
    super.key,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImage,
    this.variantName,
    required this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
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
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {


            final review = ReviewEntity(
              id: '', // Will be ignored by repo
              productId: widget.productId,
              userId: widget.userId,
              userName: widget.userName,
              userImage: widget.userImage,
              rating: _rating,
              comment: _commentController.text.trim(),
              createdAt: DateTime.now(),
              variantName: widget.variantName,
            );
            widget.onSubmit(review);
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
