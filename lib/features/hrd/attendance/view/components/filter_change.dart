import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/utils/enum/filter.dart';

import 'package:presentech/shared/view/components/custom_filter_chip.dart';

class FilterChangeAttendance extends GetView<HrdAttendanceController> {
  const FilterChangeAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Obx(
          () => CustomFilterChip(
            label: "Today",
            isSelected: controller.selectedFilter.value == AbsenceFilter.today,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.today);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Week",
            isSelected: controller.selectedFilter.value == AbsenceFilter.week,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.week);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Month",
            isSelected: controller.selectedFilter.value == AbsenceFilter.month,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.month);
            },
          ),
        ),
      ],
    );
  }
}
