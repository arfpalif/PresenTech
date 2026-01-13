import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class BtnRight extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final IconData? icon;

  const BtnRight({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.borderRadius = 5,
    this.height,
    this.width,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [
          ColorStyle.greenPrimary.withOpacity(0.1),
          ColorStyle.greenSecondary.withOpacity(0.3),
        ];
    return Card(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: ColorStyle.greenPrimary),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: height,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: Text(
                text,
                style:
                    textStyle ??
                    AppTextStyle.heading1.copyWith(
                      color: Colors.black,
                      fontSize: 10,
                    ),
              ),
            ),
            Icon(icon != null ? icon! : Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
