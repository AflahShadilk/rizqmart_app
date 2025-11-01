import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Padding fieldCatogoryName(String name) {
    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(name,style: GoogleFonts.poppins(color: Colors.black,fontSize: 15),));
  }

  Align fieldHeadline(String name) {
    return Align(
                      alignment: Alignment.topCenter,
                      child: Text(name,style:GoogleFonts.poppins(color:Colors.black,fontSize: 21,fontWeight: FontWeight.bold ),));
  }