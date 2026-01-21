import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/absence/views/components/absence_summary.dart';
import 'package:presentech/features/employee/absence/views/components/card_absence.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/employee/absence/views/components/month_slider.dart';
import 'package:presentech/shared/styles/color_style.dart';

class AbsenceWidget extends GetView<PresenceController> {
  const AbsenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Riwayat Absensi",
          style: AppTextStyle.title.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CardAbsence(),
            const SizedBox(height: 24),
            MonthSlider(),
            const SizedBox(height: 16),
            AbsenceSummary(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
