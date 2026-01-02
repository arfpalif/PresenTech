import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/permissions/view/ui/employee_permission_detail.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class PermissionList<T> extends GetView<EmployeePermissionController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.permissions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final t = controller.permissions[index];
          return Card(
            shadowColor: Colors.transparent,
            color: AppColors.greyprimary,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              onTap: () {
                Get.to(EmployeePermissionDetail(), arguments: t);
              },
              contentPadding: const EdgeInsets.all(10),
              leading: StatusBadge(status: t.status),
              title: Text(
                t.reason,
                style: AppTextStyle.heading2.copyWith(color: Colors.black),
              ),
              subtitle: Text(
                "Dibuat : ${t.createdAtYmd} | ${t.type}",
                style: AppTextStyle.normal.copyWith(color: Colors.grey),
              ),
              trailing: ComponentBadgets(status: t.status),
            ),
          );
        },
      );
    });
  }
}
