import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details/widgets/add_review_dialog.dart';

// ---------------- Order Review Button ----------------

class OrderReviewButton extends StatefulWidget {
  // ---------------- Variables ----------------
  final CartEntities item;

  // ---------------- Constructor ----------------
  const OrderReviewButton({super.key, required this.item});

  @override
  State<OrderReviewButton> createState() => _OrderReviewButtonState();
}

class _OrderReviewButtonState extends State<OrderReviewButton> {
  bool _isSubmitting = false;

  // ---------------- Helper Methods ----------------
  void _showReviewDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (ctx) => AddReviewDialog(
          productId: widget.item.id,
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userImage: user.photoURL,
          variantName: widget.item.variantDetails.isNotEmpty
              ? widget.item.variantDetails[widget.item.variantIndex]['variantName'] as String?
              : null,
          onSubmit: (review) {
            setState(() => _isSubmitting = true);
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
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (_isSubmitting && state is ReviewAddedSuccess) {
          setState(() => _isSubmitting = false);
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              backgroundColor: context.cs.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/lottie/Success.json', width: 120, height: 120, repeat: false),
                  const SizedBox(height: 16),
                  Text('Review Submitted!', style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
          
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted && Navigator.canPop(context)) {
              Navigator.pop(context); // Close the animation dialog
            }
          });
          
        } else if (_isSubmitting && state is ReviewError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.cs.error,
            ),
          );
        }
      },
      child: OutlinedButton(
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
      ),
    );
  }
}
