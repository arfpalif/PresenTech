import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/utils/enum/permission_status.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                "No permissions requests found",
                style: AppTextStyle.normal.copyWith(color: Colors.grey[500]),
              ),
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
          final statusColor = _getPermissionColor(t.status);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: InkWell(
              onTap: () async {
                final result = await Get.toNamed(
                  Routes.hrdPermissionDetail,
                  arguments: t,
                );
                if (result == true) {
                  controller.fetchPermissionsByDay();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 20,
                        bottom: 20,
                        child: Container(
                          width: 4,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.reason,
                                    maxLines: 1,
                                    style: AppTextStyle.heading2.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 14,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        t.createdAtYmd,
                                        style: AppTextStyle.normal.copyWith(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 3,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        t.type.name.capitalizeFirst!,
                                        style: AppTextStyle.normal.copyWith(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ComponentBadgets(status: t.status),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (t.status == PermissionStatus.pending)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AppGradientButtonRed(
                              text: "Reject",
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  Routes.hrdPermissionDetail,
                                  arguments: t,
                                );
                                if (result == true) {
                                  controller.fetchPermissionsByDay();
                                }
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
            ),
          );
        },
      );
    });
  }

  Color _getPermissionColor(dynamic status) {
    if (status is PermissionStatus) {
      status = status.name;
    } else {
      status = status.toString().toLowerCase().split('.').last;
    }

    switch (status) {
      case 'approved':
        return ColorStyle.greenPrimary;
      case 'pending':
        return ColorStyle.yellowPrimary;
      case 'rejected':
        return ColorStyle.redPrimary;
      default:
        return Colors.grey;
    }
  }
}
