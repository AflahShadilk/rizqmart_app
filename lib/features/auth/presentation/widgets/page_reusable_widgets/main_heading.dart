import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class AppHeading extends StatelessWidget {
  final String text;

  const AppHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(textStyle: context.ts.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        
        color: context.cs.onSurface,
      ),)
    );
  }
}
