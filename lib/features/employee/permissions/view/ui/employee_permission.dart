import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/features/employee/permissions/view/components/permission_list.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_add_permission.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/custom_filter_chip.dart';

// ignore: must_be_immutable
class EmployeePermission extends GetView<EmployeePermissionController> {
  bool isSelectedWeek = false;
  bool isSelectedToday = false;

  EmployeePermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Permissions',
          style: AppTextStyle.title.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      floatingActionButton: OpenContainer(
        closedElevation: 6,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        closedColor: ColorStyle.greenPrimary,
        closedBuilder: (context, openContainer) => SizedBox(
          height: 56,
          width: 56,
          child: Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
        openBuilder: (context, closeContainer) {
          Get.lazyPut(() => EmployeePermissionController());
          Get.lazyPut(() => DateController());
          return EmployeeAddPermission();
        },
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  spacing: 12,
                  children: [
                    Obx(
                      () => CustomFilterChip(
                        label: "Today",
                        isSelected:
                            controller.selectedFilter.value ==
                            PermissionFilter.today,
                        onSelected: (value) =>
                            controller.changeFilter(PermissionFilter.today),
                      ),
                    ),
                    Obx(
                      () => CustomFilterChip(
                        label: "This Week",
                        isSelected:
                            controller.selectedFilter.value ==
                            PermissionFilter.week,
                        onSelected: (value) =>
                            controller.changeFilter(PermissionFilter.week),
                      ),
                    ),
                    Obx(
                      () => CustomFilterChip(
                        label: "This Month",
                        isSelected:
                            controller.selectedFilter.value ==
                            PermissionFilter.month,
                        onSelected: (value) =>
                            controller.changeFilter(PermissionFilter.month),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                if (controller.permissions.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Icon(
                          Icons.assignment_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        const Text("No permissions found"),
                      ],
                    ),
                  );
                }
                return PermissionList();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
