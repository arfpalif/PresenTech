import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdPermissionList extends GetView<HrdPermissionController> {
  const HrdPermissionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.permissions.isEmpty) {
        return const Text("Belum ada izin masuk");
      }

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
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Get.to(() {});
                  },
                  contentPadding: const EdgeInsets.all(10),
                  leading: StatusBadge(status: t.status),
                  title: Text(
                    t.reason,
                    style: AppTextStyle.heading2.copyWith(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Dibuat : ${t.createdAtYmd} | Type : ${t.type}",
                    style: AppTextStyle.normal.copyWith(color: Colors.grey),
                  ),
                  trailing: ComponentBadgets(status: t.status),
                ),
                if (t.status.toString().toLowerCase() == 'pending')
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AppGradientButtonRed(
                            text: "Reject",
                            onPressed: () {
                              controller.rejectPermission(t.id!);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppGradientButtonGreen(
                            text: "Accept",
                            onPressed: () {
                              controller.approvePermission(t.id!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}
