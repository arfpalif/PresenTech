import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_controller.dart';
import 'package:presentech/features/hrd/permission/model/permission.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdPermission extends GetView<HrdPermissionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HRD Permission Page',
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.colorSecondary],
            ),
          ),
        ),
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
                        print("Hari ini");
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
                        print("Seminggu");
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
                        print("Sebulan");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
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
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Dibuat : ${t.createdAtYmd} | Type : ${t.type}",
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
