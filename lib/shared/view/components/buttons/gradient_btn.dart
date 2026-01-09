import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

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
    this.height = 40,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ?? [ColorStyle.colorPrimary, ColorStyle.colorSecondary];
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
                    style:
                        textStyle ??
                        AppTextStyle.normal.copyWith(color: Colors.white),
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
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButtonGreen({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,
    this.height = 40,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ?? [ColorStyle.greenPrimary, ColorStyle.greenSecondary];
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
                    style:
                        textStyle ??
                        AppTextStyle.normal.copyWith(color: Colors.white),
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
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;

  const AppGradientButtonRed({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,
    this.height = 40,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [ColorStyle.redPrimary, ColorStyle.redSecondary.withValues(alpha: 0.8)];
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
                    style:
                        textStyle ??
                        AppTextStyle.normal.copyWith(color: Colors.white),
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
    this.height = 40,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [ColorStyle.yellowPrimary, ColorStyle.yellowSecondary];
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
                    style:
                        textStyle ??
                        AppTextStyle.normal.copyWith(color: Colors.white),
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

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;
  final Image? icon;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius = 5,
    this.height = 40,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = color ?? Colors.white;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              color: colors,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(borderRadius),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[icon!, SizedBox(width: 8)],
                      Text(
                        text,
                        style:
                            textStyle ??
                            AppTextStyle.heading2.copyWith(color: Colors.black),
                      ),
                    ],
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

class AppDeactivatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;
  final Image? icon;

  const AppDeactivatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius = 5,
    this.height = 40,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = color ?? Colors.grey.withValues(alpha: 0.3);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool bounded = constraints.hasBoundedWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: bounded ? double.infinity : null,
            decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.circular(borderRadius),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[icon!, SizedBox(width: 8)],
                      Text(
                        text,
                        style:
                            textStyle ??
                            AppTextStyle.heading2.copyWith(color: Colors.black),
                      ),
                    ],
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
