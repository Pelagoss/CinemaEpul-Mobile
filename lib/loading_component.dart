import 'dart:ui';

import 'package:cinemaepulmobile/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLoading(context) {
  return Scaffold(
    backgroundColor: backColor,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(
                        color: accentColor,
                      ),
                    ),
                    Text(
                      "Chargement ...",
                      style:
                          GoogleFonts.poppins(color: textColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildLoadingData() {
  return Expanded(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          ),
          Text(
            "Chargement ...",
            style: GoogleFonts.poppins(color: textColor, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}
