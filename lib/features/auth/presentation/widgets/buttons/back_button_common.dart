import 'package:flutter/material.dart';
class BackButtonCommon extends StatelessWidget {
final ColorScheme? colorScheme;
const BackButtonCommon({
    super.key,
    this.colorScheme,
  });
@override
  Widget build(BuildContext context) {
    final activeColorScheme = colorScheme ?? Theme.of(context).colorScheme;
    
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_new_outlined,
        color: activeColorScheme.onSecondary,
        size: 20,
      ),
    );
  }
}
