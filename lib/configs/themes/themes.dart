import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes extends StatelessWidget {
  const Themes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppTextStyle {
  static TextStyle title = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle normal = GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  );
  static TextStyle smallText = GoogleFonts.poppins(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
  );
}
