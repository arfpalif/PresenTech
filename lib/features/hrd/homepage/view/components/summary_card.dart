import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/homepage/view/components/summary_item.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({super.key});
  final attendaceC = Get.find<HrdAttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SummaryItem(label: "Hadir\n ${attendaceC.hadir.value}"),
            SummaryItem(label: "telat\n ${attendaceC.telat.value}"),
            SummaryItem(label: "Alpha\n ${attendaceC.alfa.value}"),
          ],
        );
      }),
    );
  }
}
