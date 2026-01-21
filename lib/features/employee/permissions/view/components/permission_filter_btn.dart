import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';

import 'package:presentech/shared/view/components/custom_filter_chip.dart';
import 'package:presentech/utils/enum/permission_filter.dart';

import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/shared/styles/color_style.dart';

class PermissionFilterBtn extends GetView<EmployeePermissionController> {
  const PermissionFilterBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          // Date Filters
          _buildFilterSection(
            children: [
              CustomFilterChip(
                label: "Today",
                isSelected:
                    controller.selectedFilter.value == PermissionFilter.today,
                onSelected: (val) =>
                    controller.changeFilter(PermissionFilter.today),
              ),
              CustomFilterChip(
                label: "This Week",
                isSelected:
                    controller.selectedFilter.value == PermissionFilter.week,
                onSelected: (val) =>
                    controller.changeFilter(PermissionFilter.week),
              ),
              CustomFilterChip(
                label: "This Month",
                isSelected:
                    controller.selectedFilter.value == PermissionFilter.month,
                onSelected: (val) =>
                    controller.changeFilter(PermissionFilter.month),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: 1,
              height: 24,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),

          // Status Filters
          _buildFilterSection(
            children: [
              CustomFilterChip(
                label: "Approved",
                isSelected:
                    controller.selectedStatus.value ==
                    PermissionStatus.approved,
                onSelected: (val) =>
                    controller.changeStatusFilter(PermissionStatus.approved),
                selectedColor: ColorStyle.greenPrimary,
              ),
              CustomFilterChip(
                label: "Rejected",
                isSelected:
                    controller.selectedStatus.value ==
                    PermissionStatus.rejected,
                onSelected: (val) =>
                    controller.changeStatusFilter(PermissionStatus.rejected),
                selectedColor: ColorStyle.redPrimary,
              ),
              CustomFilterChip(
                label: "Cancelled",
                isSelected:
                    controller.selectedStatus.value ==
                    PermissionStatus.cancelled,
                onSelected: (val) =>
                    controller.changeStatusFilter(PermissionStatus.cancelled),
                selectedColor: Colors.orange,
              ),
              CustomFilterChip(
                label: "Pending",
                isSelected:
                    controller.selectedStatus.value == PermissionStatus.pending,
                onSelected: (val) =>
                    controller.changeStatusFilter(PermissionStatus.pending),
                selectedColor: Colors.blue,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildFilterSection({required List<Widget> children}) {
    return Row(spacing: 8, children: children);
  }
}
