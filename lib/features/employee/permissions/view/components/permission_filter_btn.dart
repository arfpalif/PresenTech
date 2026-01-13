import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';

import 'package:presentech/shared/view/components/custom_filter_chip.dart';

class PermissionFilterBtn extends GetView<EmployeePermissionController> {
  const PermissionFilterBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Obx(
          () => CustomFilterChip(
            label: "Today",
            isSelected: controller.selectedFilter.value == PermissionFilter.today,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.today);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Week",
            isSelected: controller.selectedFilter.value == PermissionFilter.week,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.week);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Month",
            isSelected: controller.selectedFilter.value == PermissionFilter.month,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.month);
            },
          ),
        ),
      ],
    );
  }
}
