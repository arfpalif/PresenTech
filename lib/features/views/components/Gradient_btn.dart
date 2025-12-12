import 'package:flutter/material.dart';
import 'package:presentech/features/views/themes/themes.dart';

class AppGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,
    this.height = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? 
      [AppColors.colorPrimary, AppColors.colorSecondary];
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    text,
                    style: textStyle ?? AppTextStyle.normal.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppGradientButtonGreen extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButtonGreen({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,  
    this.height = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? 
      [AppColors.greenPrimary, AppColors.greenSecondary];
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    text,
                    style: textStyle ?? AppTextStyle.normal.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppGradientButtonRed extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButtonRed({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,  
    this.height = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? 
      [AppColors.redPrimary, AppColors.redSecondary];
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    text,
                    style: textStyle ?? AppTextStyle.normal.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppGradientButtonYellow extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButtonYellow({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,  
    this.height = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? 
      [AppColors.redPrimary, AppColors.redSecondary];
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                child: Container(
                  height: height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    text,
                    style: textStyle ?? AppTextStyle.normal.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}