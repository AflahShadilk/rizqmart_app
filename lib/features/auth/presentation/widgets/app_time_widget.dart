import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AppTimeWidget extends StatelessWidget {
  final DateTime time;
  final TextStyle? style;

  const AppTimeWidget({super.key, required this.time, this.style});
  static String format(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Text(format(time), style: style);
  }
}
