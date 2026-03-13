import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class IconRizq extends StatelessWidget {
  const IconRizq({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/icons_and_images/appIcon.png");
  }
}
class RizqMartName extends StatelessWidget {
  const RizqMartName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'RIZQ',
          style: context.ts.headlineLarge?.copyWith(
            color: context.cs.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          ' MART',
          style: context.ts.headlineLarge?.copyWith(
            color: context.cs.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}