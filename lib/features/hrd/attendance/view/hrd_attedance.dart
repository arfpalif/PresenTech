import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdAttedance extends GetView<HrdAttendanceController> {
  HrdAttedance({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HRD Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Obx(
                  () => FilterChip(
                    label: Text("Today"),
                    selected:
                        controller.selectedFilter.value == AbsenceFilter.today,
                    onSelected: (bool value) {
                      controller.changeFilter(AbsenceFilter.today);
                      print("Hari ini");
                    },
                  ),
                ),
                Obx(
                  () => FilterChip(
                    label: Text("This weeks"),
                    selected:
                        controller.selectedFilter.value == AbsenceFilter.week,
                    onSelected: (bool value) {
                      controller.changeFilter(AbsenceFilter.week);
                      print("Seminggu");
                    },
                  ),
                ),
                Obx(
                  () => FilterChip(
                    label: Text("This month"),
                    selected:
                        controller.selectedFilter.value == AbsenceFilter.month,
                    onSelected: (bool value) {
                      controller.changeFilter(AbsenceFilter.month);
                      print("Sebulan");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.absences.isEmpty) {
                  return Center(child: Text("Belum ada absensi"));
                }
                return ListView.builder(
                  itemCount: controller.absences.length,
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
                              t.userName ?? "No Name",
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              // ignore: unnecessary_null_comparison
                              "Tanggal: ${DateFormat('dd-MM-yyyy').format(t.date)} \n Masuk : ${t.clockIn.isNotEmpty ? t.clockIn.substring(0, 5) : '-'} | Keluar : ${t.clockOut != null && t.clockOut.isNotEmpty ? t.clockOut.substring(0, 5) : '-'}",
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
            ),
          ],
        ),
      ),
    );
  }
}
