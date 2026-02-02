import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/btn_right.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceList extends GetView<HrdAttendanceController> {
  const AbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rekap Absensi Karyawan", style: AppTextStyle.heading1),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.hrdAbsen);
                  },
                  child: BtnRight(text: "Lihat semua", onPressed: () {}),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.absences.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Belum ada riwayat absensi",
                        style: AppTextStyle.normal.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              String formatTime(String? time) {
                if (time == null || time.isEmpty) return '-';
                try {
                  return time.length >= 5 ? time.substring(0, 5) : time;
                } catch (_) {
                  return time;
                }
              }

              return ListView.builder(
                itemCount: controller.absences.length > 3
                    ? 3
                    : controller.absences.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final t = controller.absences[index];
                  return Card(
                    shadowColor: Colors.transparent,
                    color: ColorStyle.greyprimary,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: StatusBadge(status: t.status),
                      title: Text(
                        t.userName ?? "No Name",
                        style: AppTextStyle.heading2.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "Masuk : ${formatTime(t.clockIn)} | Keluar : ${formatTime(t.clockOut)}",
                        style: AppTextStyle.normal.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: ComponentBadgets(status: t.status),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
