import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/utils/enum/filter.dart';

class FilterChangeAttendance extends GetView<HrdAttendanceController> {
  const FilterChangeAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Obx(
          () => FilterChip(
            label: Text("Today"),
            selected: controller.selectedFilter.value == AbsenceFilter.today,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.today);
              print("Hari ini");
            },
          ),
        ),
        Obx(
          () => FilterChip(
            label: Text("This weeks"),
            selected: controller.selectedFilter.value == AbsenceFilter.week,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.week);
              print("Seminggu");
            },
          ),
        ),
        Obx(
          () => FilterChip(
            label: Text("This month"),
            selected: controller.selectedFilter.value == AbsenceFilter.month,
            onSelected: (bool value) {
              controller.changeFilter(AbsenceFilter.month);
              print("Sebulan");
            },
          ),
        ),
      ],
    );
  }
}
