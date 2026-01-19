import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/shared/view/widgets/absence_card.dart';

class AbsenceList extends GetView<HrdAttendanceController> {
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
        itemCount:
            controller.absences.length > 3 ? 3 : controller.absences.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final t = controller.absences[index];
          return AbsenceCard(
            absence: t,
            title: t.userName ?? 'Unknown user',
          );
        },
      );
    });
  }
}
