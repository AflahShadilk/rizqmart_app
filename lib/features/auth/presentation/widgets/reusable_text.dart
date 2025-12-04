import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  
   // ignore: prefer_const_constructors_in_immutables
   ReusableText({
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