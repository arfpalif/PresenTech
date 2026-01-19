import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/absence/views/components/absence_list.dart';
import 'package:presentech/features/employee/absence/views/components/absence_summary.dart';
import 'package:presentech/features/employee/absence/views/components/card_absence.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/employee/absence/views/components/month_slider.dart';

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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CardAbsence(),
                    SizedBox(height: 20),
                    MonthSlider(),
                    AbsenceSummary(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
