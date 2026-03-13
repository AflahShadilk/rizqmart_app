import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AppDateWidget extends StatelessWidget {
  final DateTime date;
  final TextStyle? style;

  const AppDateWidget({super.key, required this.date, this.style});
  static String format(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Text(format(date), style: style);
  }
}
