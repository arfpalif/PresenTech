import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';

class FilterChange extends GetView<HrdPermissionController> {
  const FilterChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Obx(
          () => FilterChip(
            label: Text("Today"),
            selected: controller.selectedFilter.value == PermissionFilter.today,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.today);
              print("Hari ini");
            },
          ),
        ),
        Obx(
          () => FilterChip(
            label: Text("This weeks"),
            selected: controller.selectedFilter.value == PermissionFilter.week,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.week);
              print("Seminggu");
            },
          ),
        ),
        Obx(
          () => FilterChip(
            label: Text("This month"),
            selected: controller.selectedFilter.value == PermissionFilter.month,
            onSelected: (bool value) {
              controller.changeFilter(PermissionFilter.month);
              print("Sebulan");
            },
          ),
        ),
      ],
    );
  }
}
