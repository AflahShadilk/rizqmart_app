import 'package:flutter/material.dart';

class BackButtonCommon extends StatelessWidget {
  const BackButtonCommon({
    super.key,
    required this.colorScheme,
    
  });
  
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_ios_new_outlined,
          color: colorScheme.onSecondary, size: 20),
    );
  }
}