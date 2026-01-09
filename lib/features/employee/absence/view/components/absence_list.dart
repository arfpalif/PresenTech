import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceList extends GetView<PresenceController> {
  const AbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.absences.isEmpty) {
        return const Text("Belum ada absensi");
      }

      return ListView.builder(
        itemCount: controller.absences.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final t = controller.absences[index];
          return Card(
            shadowColor: Colors.transparent,
            color: ColorStyle.greyprimary,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: StatusBadge(status: t.status),
              title: Text(
                DateFormat('dd-MM-yyyy').format(t.date),
                style: AppTextStyle.heading2.copyWith(color: Colors.black),
              ),
              subtitle: Text(
                "Masuk : ${t.clockIn} | Keluar : ${t.clockOut}",
                style: AppTextStyle.normal.copyWith(color: Colors.grey),
              ),
              trailing: ComponentBadgets(status: t.status),
            ),
          );
        },
      );
    });
  }
}
