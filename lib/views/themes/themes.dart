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
    static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );
  static TextStyle normal = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );
  
}
class AppColors {
  static const colorPrimary = Color(0xff3B82F6);
  static const colorSecondary = Color(0xff1E40AF);
  static const greenPrimary = Color(0xff10B981);
  static const greenSecondary = Color(0xff34D399);
  static const greyprimary = Color(0xffF9FAFB);
}

// Custom Gradient Button Widget
class AppGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,
    this.height = 50,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? 
      [AppColors.colorPrimary, AppColors.colorSecondary];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(double.infinity, height),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ?? AppTextStyle.normal.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}