import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class AiLoadingIndicator extends StatefulWidget {
  const AiLoadingIndicator({super.key});

  @override
  State<AiLoadingIndicator> createState() => _AiLoadingIndicatorState();
}

class _AiLoadingIndicatorState extends State<AiLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _pulse,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  context.cs.primary,
                  context.cs.tertiary,
                  context.cs.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'AI is preparing your list…',
            style: context.ts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hang tight, this takes a moment',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 24),
          _AnimatedDots(),
        ],
      ),
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final step = (_ctrl.value * 3).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == step ? 10 : 7,
              height: i == step ? 10 : 7,
              decoration: BoxDecoration(
                color: i == step
                    ? context.cs.primary
                    : context.cs.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
