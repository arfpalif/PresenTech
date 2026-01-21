import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';

import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/widgets/absence_card.dart';

class AbsenceList extends GetView<PresenceController> {
  const AbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.absences.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.history_rounded, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                "Belum ada riwayat absensi",
                style: AppTextStyle.normal.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.absences.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final t = controller.absences[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: AbsenceCard(
              absence: t,
              title: DateFormat('EEEE, dd MMM yyyy').format(t.date),
            ),
          );
        },
      );
    });
  }
}
