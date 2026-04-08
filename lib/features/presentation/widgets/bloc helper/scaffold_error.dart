
  

  import 'package:flutter/material.dart';
import 'package:rizqmart/features/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Error Message SnackBar ----------------

/// Returns a floating, custom styled SnackBar widget used to display loading failure errors.
class ErrorMessageSnackBar {
  static SnackBar build(FailureLoadingProductState state) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            12.w,
            Expanded(
              child: Text(
                state.error,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}