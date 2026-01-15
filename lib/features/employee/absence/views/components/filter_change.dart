import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/utils/enum/filter.dart';

import 'package:presentech/shared/view/components/custom_filter_chip.dart';

class FilterChange extends GetView<PresenceController> {
  const FilterChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Obx(
          () => CustomFilterChip(
            label: "Today",
            isSelected: controller.selectedFilter.value == DateFilter.today,
            onSelected: (bool value) {
              controller.changeFilter(DateFilter.today);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Week",
            isSelected: controller.selectedFilter.value == DateFilter.week,
            onSelected: (bool value) {
              controller.changeFilter(DateFilter.week);
            },
          ),
        ),
        Obx(
          () => CustomFilterChip(
            label: "This Month",
            isSelected: controller.selectedFilter.value == DateFilter.month,
            onSelected: (bool value) {
              controller.changeFilter(DateFilter.month);
            },
          ),
        ),
      ],
    );
  }
}
