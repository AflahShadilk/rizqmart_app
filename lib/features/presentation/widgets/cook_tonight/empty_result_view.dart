import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';

class EmptyResultView extends StatelessWidget {
  final VoidCallback onRetry;

  const EmptyResultView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_meals_rounded,
              size: 72,
              color: context.cs.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 20),
            Text(
              'No Ingredients Found',
              style: context.ts.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI couldn\'t generate a grocery list for this dish. Try a different name.',
              textAlign: TextAlign.center,
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              height: 48,
              child: MainButton(
                label: 'Try Again',
                icon: Icons.refresh_rounded,
                onPress: onRetry,
                color: context.cs.primary,
                textColor: context.cs.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
