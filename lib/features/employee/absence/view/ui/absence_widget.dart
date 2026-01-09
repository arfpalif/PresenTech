import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/features/employee/absence/view/components/absence_list.dart';
import 'package:presentech/features/employee/absence/view/components/filter_change.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceWidget extends GetView<PresenceController> {
  const AbsenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Absensi",
          style: AppTextStyle.heading1.copyWith(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FilterChange(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [AbsenceList(), SizedBox(height: 10)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
