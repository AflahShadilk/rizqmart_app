import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable styling method for generating a primary Elevated Button.
ElevatedButton elevatedButton(double fontSize,{required void Function()?onpress,required Color color,required EdgeInsetsGeometry? padd,required String content }) {
    return ElevatedButton(
                        onPressed: onpress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          content,
                          style: GoogleFonts.poppins(
                            fontSize: fontSize * 0.85,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
  }

  