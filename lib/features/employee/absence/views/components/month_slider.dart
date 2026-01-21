import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';

class MonthSlider extends GetView<PresenceController> {
  const MonthSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => controller.prevMonth(),
              icon: const Icon(Icons.chevron_left_rounded, color: Colors.black),
              splashRadius: 24,
            ),
          ),
          Obx(
            () => Text(
              DateFormat('MMMM yyyy').format(controller.selectedDate.value),
              style: AppTextStyle.heading2.copyWith(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => controller.nextMonth(),
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black,
              ),
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
