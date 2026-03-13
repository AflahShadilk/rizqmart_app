import 'package:flutter/material.dart';
class ReusableText extends StatelessWidget {
final String texts;
  final TextStyle? titleSize;
const ReusableText({
    super.key,
    required this.texts,
    required this.titleSize,
  });
@override
  Widget build(BuildContext context) {
    return Text(
      texts,
      style: titleSize,
    );
  }
}