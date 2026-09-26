import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- Edit Save Button ----------------

class EditSaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const EditSaveButton({
    super.key,
    required this.onSave,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.cs.primary,
          foregroundColor: context.cs.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Save Changes',
          style: context.ts.labelLarge?.copyWith(
            color: context.cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
