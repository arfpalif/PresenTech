import 'package:flutter/material.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class ComponentBadgets extends StatelessWidget {
  final String status;

  const ComponentBadgets({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'hadir':
        return SizedBox(
          height: 32,
          width: 60,
          child: AppGradientButtonGreen(
            text: "Hadir",
            textStyle: AppTextStyle.heading1.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        );

      case 'telat':
        return SizedBox(
          height: 32,
          width: 60,
          child: AppGradientButtonYellow(
            text: "Telat",
            textStyle: AppTextStyle.heading1.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        );

      case 'alfa':
        return SizedBox(
          height: 32,
          width: 60,
          child: AppGradientButtonRed(
            text: "Alfa",
            textStyle: AppTextStyle.heading1.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
            onPressed: () {}, // read-only
          ),
        );

      case 'pending':
        return SizedBox(
          height: 32,
          width: 70,
          child: AppGradientButtonYellow(
            text: "Pending",
            textStyle: AppTextStyle.normal.copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
            onPressed: () {},
          ),
        );

      case 'approved':
        return SizedBox(
          height: 32,
          width: 90,
          child: AppGradientButtonGreen(
            text: "Approved",
            textStyle: AppTextStyle.heading1.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );

      case 'rejected':
        return SizedBox(
          height: 32,
          width: 80,
          child: AppGradientButtonRed(
            text: "Rejected",
            textStyle: AppTextStyle.heading1.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        );

      default:
        return SizedBox(
          height: 32,
          width: 60,
          child: AppGradientButton(text: "-", onPressed: () {}),
        );
    }
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'hadir':
      return AppColors.greenPrimary;
    case 'telat':
      return AppColors.yellowPrimary;
    case 'alfa':
      return AppColors.redPrimary;
    default:
      return Colors.grey;
  }
}

String statusText(String status) {
  return status.toUpperCase();
}
