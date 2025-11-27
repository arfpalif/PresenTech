import 'package:flutter/material.dart';

class Themes extends StatelessWidget {
  const Themes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AppTextStyle {
   static const heading1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  static const heading2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );
  static const normal = TextStyle(
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