import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_state.dart';

// ---------------- Onboarding Indicator ----------------

/// Animated page indicator dots for the onboarding flow.
class OnboardingIndicator extends StatelessWidget {
  final int pageCount;
  final AnimationController animationController;

  const OnboardingIndicator({
    super.key,
    required this.pageCount,
    required this.animationController,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeCubit, WelcomeState>(
      builder: (context, state) {
        final currentPage =
            (state is WelcomePageUpdated) ? state.currentPage : 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: currentPage == index ? 28 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
