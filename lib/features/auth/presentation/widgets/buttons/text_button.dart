import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

 textButtonAuth(BuildContext context,{required void Function()?onpress,required String content,required Color color}) {
    return TextButton(
      onPressed:onpress,
      child: Text(
        content,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }