import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';

class MonthSlider extends GetView<PresenceController> {
  const MonthSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            controller.prevMonth();
          },
          icon: Icon(Icons.chevron_left),
        ),
        Obx(
          () => Text(
            DateFormat('MMMM yyyy').format(controller.selectedDate.value),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () {
            controller.nextMonth();
          },
          icon: Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
