import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceList extends GetView<PresenceController> {
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
      String formatTime(String? time) {
        if (time == null || time.isEmpty) return '-';
        try {
          return time.length >= 5 ? time.substring(0, 5) : time;
        } catch (_) {
          return time;
        }
      }

      return ListView.builder(
        itemCount: controller.absences.length,
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
                    "${DateFormat('dd-MMM-yyyy').format(t.date) ?? 'Unknown user'} ",
                    style: AppTextStyle.heading2.copyWith(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Masuk : ${formatTime(t.clockIn)} | Keluar : ${formatTime(t.clockOut)}",
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
