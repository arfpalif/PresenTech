import 'package:flutter/material.dart';
import 'package:presentech/shared/styles/color_style.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }
}
