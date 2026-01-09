import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class HrdPermissionList extends GetView<HrdPermissionController> {
  const HrdPermissionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.permissions.isEmpty) {
        return Center(
          child: Column(
            children: [
               Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
               SizedBox(height: 16),
               const Text("Belum ada izin masuk", style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

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
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Get.to(() {});
                  },
                  contentPadding: const EdgeInsets.all(16),
                  leading: StatusBadge(status: t.status),
                  title: Text(
                    t.reason,
                    style: AppTextStyle.heading2.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Dibuat : ${t.createdAtYmd} | Type : ${t.type}",
                      style: AppTextStyle.normal.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  trailing: ComponentBadgets(status: t.status),
                ),
                if (t.status.toString().toLowerCase() == 'pending')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                        const SizedBox(width: 12),
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
