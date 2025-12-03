import 'package:flutter/material.dart';
import 'package:presentech/views/themes/themes.dart';

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