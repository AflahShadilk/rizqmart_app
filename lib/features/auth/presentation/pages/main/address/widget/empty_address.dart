// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class EmptyAddressView extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressView({
    super.key,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 120,
              color: context.cs.onSurfaceVariant.withOpacity(0.5),
            ),
            24.h,
            Text(
              'No Addresses Yet',
              style: context.ts.headlineSmall?.copyWith(
                color: context.cs.onSurface,
              ),
            ),
            12.h,
            Text(
              'Add your delivery address to get started',
              textAlign: TextAlign.center,
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
            ),
            32.h,
            ElevatedButton.icon(
              onPressed: onAddAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.cs.primary,
                foregroundColor: context.cs.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}