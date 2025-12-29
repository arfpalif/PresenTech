import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class AbsenceListHomepage extends GetView<PresenceController> {
  AbsenceListHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Riwayat absensi", style: AppTextStyle.heading1),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.employee_absence_history);
              },
              child: Text(
                "View All",
                style: AppTextStyle.normal.copyWith(
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.absences.isEmpty) {
            return Text("Belum ada absensi");
          }
          return ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final t = controller.absences[index];
              return Card(
                shadowColor: Colors.transparent,
                color: AppColors.greyprimary,
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: StatusBadge(status: t.status),
                      title: Text(
                        DateFormat('dd-MM-yyyy').format(t.date),
                        style: AppTextStyle.heading2.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "Masuk : ${t.clockIn.toString()} keluar : ${t.clockOut.toString()}",
                        style: AppTextStyle.normal.copyWith(color: Colors.grey),
                      ),
                      trailing: ComponentBadgets(status: t.status),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
