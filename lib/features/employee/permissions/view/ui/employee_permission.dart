import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/features/employee/permissions/view/components/permission_list.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_add_permission.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

// ignore: must_be_immutable
class EmployeePermission extends GetView<EmployeePermissionController> {
  bool isSelectedWeek = false;
  bool isSelectedToday = false;

  EmployeePermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permissions',
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.greenPrimary],
            ),
          ),
        ),
      ),
      floatingActionButton: OpenContainer(
        closedBuilder: (context, openContainer) => FloatingActionButton(
          onPressed: openContainer,
          backgroundColor: AppColors.colorSecondary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Obx(
                    () => FilterChip(
                      label: Text("Today"),
                      selected:
                          controller.selectedFilter.value ==
                          PermissionFilter.today,
                      onSelected: (bool value) {
                        controller.changeFilter(PermissionFilter.today);
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This weeks"),
                      selected:
                          controller.selectedFilter.value ==
                          PermissionFilter.week,
                      onSelected: (bool value) {
                        controller.changeFilter(PermissionFilter.week);
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This month"),
                      selected:
                          controller.selectedFilter.value ==
                          PermissionFilter.month,
                      onSelected: (bool value) {
                        controller.changeFilter(PermissionFilter.month);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.permissions.isEmpty) {
                  return const Center(child: Text("No data"));
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
