  // ignore_for_file: deprecated_member_use

  import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/dashboard/dash_state.dart';

SnackBar errorMessageScaffold(FailureLoadingProductState state) {
    return SnackBar(
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  elevation: 0,
  content: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.redAccent.withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.redAccent.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.white),
        const SizedBox(width: 12),
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