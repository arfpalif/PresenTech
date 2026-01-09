import 'package:flutter/material.dart';
import 'package:presentech/configs/themes/themes.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.normal.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
      ],
    );
  }
}
