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
  static TextStyle heading1 = TextStyle(
    fontFamily: 'Poppins',
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

class AppColors {
  static const colorPrimary = Color(0xff3B82F6);
  static const colorSecondary = Color(0xff1E40AF);
  static const greenPrimary = Color(0xff10B981);
  static const greenSecondary = Color(0xff34D399);
  static const greyprimary = Color(0xffF9FAFB);
  static const redPrimary = Color(0xffDC2626);
  static const redSecondary = Color(0xffB91C1C);
  static const yellowPrimary = Color(0xffFFB703);
  static const yellowSecondary = Color(0xffFB8500);
}
