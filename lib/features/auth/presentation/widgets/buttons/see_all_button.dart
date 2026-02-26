import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

/// A green stylized TextButton used for 'See all' navigation links.
class ReusableSeeAllButton extends StatelessWidget {
  final VoidCallback onPress;
  const ReusableSeeAllButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPress,
        child: Text(
          'See all',
          style: context.ts.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color:Colors.green),
        ));
  }
}
