import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/shared/controllers/split_time.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/btn_right.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceListHomepage extends GetView<PresenceController> {
  const AbsenceListHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Riwayat absensi", style: AppTextStyle.heading1),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.employeeAbsenceHistory);
                    },
                    child: BtnRight(text: "Lihat semua", onPressed: () {}),
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
                  itemCount: controller.absences.length > 3
                      ? 3
                      : controller.absences.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = controller.absences[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: ColorStyle.greyprimary,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: StatusBadge(status: t.status),
                            title: Text(
                              DateFormat('dd-MMM-yyyy').format(t.date),
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Absensi : ${SplitTime().formatClockInOut(t.clockIn.toString(), t.clockOut.toString())}",
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
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
          ),
        ),
      ),
    );
  }
}
