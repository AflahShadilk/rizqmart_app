import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details/widgets/add_review_dialog.dart';

// ---------------- Order Review Button ----------------

class OrderReviewButton extends StatelessWidget {
  // ---------------- Variables ----------------
  final CartEntities item;

  // ---------------- Constructor ----------------
  const OrderReviewButton({super.key, required this.item});

  // ---------------- Helper Methods ----------------
  void _showReviewDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (ctx) => AddReviewDialog(
          productId: item.id,
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userImage: user.photoURL,
          variantName: item.variantDetails.isNotEmpty
              ? item.variantDetails[item.variantIndex]['variantName'] as String?
              : null,
          onSubmit: (review) {
            context.read<ReviewBloc>().add(AddReviewEvent(review: review));
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You must be logged in to leave a review.'),
          backgroundColor: context.cs.error,
        ),
      );
    }
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showReviewDialog(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: BorderSide(color: context.cs.primary),
        foregroundColor: context.cs.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('Add Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}
