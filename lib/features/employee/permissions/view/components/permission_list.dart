import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class PermissionList<T> extends GetView<EmployeePermissionController> {
  const PermissionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.permissions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final t = controller.permissions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                Get.toNamed(Routes.employeePermissionDetail, arguments: t);
              },
              contentPadding: const EdgeInsets.all(16),
              leading: StatusBadge(status: t.status),
              title: Text(
                t.reason,
                style: AppTextStyle.heading2.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Created : ${t.createdAtYmd} | ${t.type.name}",
                      style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
                    ),
                    if (t.isSynced == 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_off_outlined,
                            size: 14,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Menunggu Sinkronisasi",
                            style: AppTextStyle.smallText.copyWith(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              trailing: ComponentBadgets(status: t.status),
            ),
          );
        },
      );
    });
  }
}
