import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class TextFieldOutlined extends StatelessWidget {
  const TextFieldOutlined({
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
    this.onChanged,
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
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyle.normal,
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration:
          decoration ??
          InputDecoration(
            labelText: labelText,
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorStyle.colorPrimary,
                width: 1.0,
              ),
            ),
          ),
      onTap: onTap,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
    );
  }
}
