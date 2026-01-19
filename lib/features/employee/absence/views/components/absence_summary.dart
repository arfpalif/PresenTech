import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/absence/views/components/absence_list.dart';

class AbsenceSummary extends GetView<PresenceController> {
  const AbsenceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          Obx(
            () => ListTile(
              title: const Text("Hadir"),
              trailing: Text(controller.hadir.toString()),
            ),
          ),
          Obx(
            () => ListTile(
              title: const Text("Telat"),
              trailing: Text(controller.telat.toString()),
            ),
          ),
          Obx(
            () => ListTile(
              title: const Text("Alfa"),
              trailing: Text(controller.alfa.toString()),
            ),
          ),
          AbsenceList(),
        ],
      );
    });
  }
}
