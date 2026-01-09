import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';

class AbsenceList extends GetView<HrdAttendanceController> {
  const AbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
            color: ColorStyle.greyprimary,
            margin: EdgeInsets.only(bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: StatusBadge(status: t.status),
                  title: Text(
                    t.userName ?? 'Unknown user',
                    style: AppTextStyle.heading2.copyWith(color: Colors.black),
                  ),
                  subtitle: Text(
                    "${DateFormat('dd-MM-yyyy').format(t.date)} | Masuk : ${t.clockIn != null && t.clockIn != null ? t.clockIn?.substring(0, 5) : '-'} | Keluar : ${t.clockOut != null && t.clockOut != null ? t.clockOut?.substring(0, 5) : '-'}",
                    style: AppTextStyle.normal.copyWith(color: Colors.grey),
                  ),
                  trailing: ComponentBadgets(status: t.status),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
