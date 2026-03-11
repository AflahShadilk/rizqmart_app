import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Add Card Form ----------------

class AddCardForm extends StatelessWidget {
  final TextEditingController nameController;
  final CardEditController cardEditController;
  final bool isProcessing;
  final VoidCallback onSave;

  const AddCardForm({
    super.key,
    required this.nameController,
    required this.cardEditController,
    required this.isProcessing,
    required this.onSave,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Card Holder Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        20.h,
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: context.cs.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CardField(
            controller: cardEditController,
            enablePostalCode: false,
            style: TextStyle(color: context.cs.onSurface),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Card Details',
              hintStyle: TextStyle(
                color: context.cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        40.h,
        SizedBox(
          width: double.infinity,
          height: 50,
          child: MainButton(
            label: isProcessing ? 'Saving...' : 'Save Card',
            onPress: isProcessing ? null : onSave,
            color: context.cs.primary,
            textColor: context.cs.onPrimary,
          ),
        ),
      ],
    );
  }
}
