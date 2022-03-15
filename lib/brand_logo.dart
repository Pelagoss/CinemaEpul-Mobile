import 'package:cinemaepulmobile/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget brand_logo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "CinEpul",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
      Text(
        ".",
        style: GoogleFonts.poppins(color: accentColor, fontSize: 48, height: 1),
      ),
    ],
  );
}
