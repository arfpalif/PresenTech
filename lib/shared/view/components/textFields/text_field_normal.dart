import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';

class TextFieldNormal extends StatelessWidget {
  const TextFieldNormal({
    super.key,
    required this.controller,
    this.keyboardType,
    this.style,
    this.obscureText,
    this.decoration,
    this.labelText,
    this.icon,
    this.onTap,
    this.readOnly,
    this.maxLines,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final bool? obscureText;
  final InputDecoration? decoration;
  final String? labelText;
  final Icon? icon;
  final dynamic onTap;
  final bool? readOnly;
  final dynamic maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyle.normal,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration:
          decoration ?? InputDecoration(labelText: labelText, prefixIcon: icon),
      onTap: onTap,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
    );
  }
}
