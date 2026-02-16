import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  
   
   const ReusableText({
    super.key,
    required this.texts,
    required this.titleSize,
   
  });
  final String texts;
  final TextStyle? titleSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      texts,
      style:titleSize,
    );
  }
}