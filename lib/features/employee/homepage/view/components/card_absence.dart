import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';

class CardAbsence extends StatelessWidget {
  CardAbsence({super.key});
  final PresenceController controller = Get.put(PresenceController());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              ColorStyle.colorPrimary,
              ColorStyle.colorSecondary.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Jadwal anda hari ini",
                        style: AppTextStyle.normal.copyWith(
                          color: ColorStyle.greenPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: ColorStyle.greenPrimary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text("08.00", style: AppTextStyle.heading2),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Text("—", style: AppTextStyle.heading2),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: ColorStyle.redPrimary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("16.00", style: AppTextStyle.heading1),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Text(
                          controller.statusAbsen.value,
                          style: AppTextStyle.normal.copyWith(
                            color: ColorStyle.greenPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Obx(() {
                  if (controller.isIzin.value) {
                    return AppDeactivatedButton(
                      text: "Izin",
                      onPressed: () {
                        FailedSnackbar.show("Anda sedang dalam status izin");
                      },
                    );
                  }
                  if (controller.clockIn.value == false) {
                    return AppGradientButtonGreen(
                      text: "Presensi masuk",
                      onPressed: () {
                        controller.submitAbsence();
                      },
                    );
                  }
                  if (controller.clockOut.value == false) {
                    return AppGradientButtonRed(
                      text: "Presensi keluar",
                      onPressed: () {
                        controller.submitAbsence();
                      },
                    );
                  }
                  return AppGradientButtonGreen(
                    text: "Anda sudah absen, hari ini",
                    onPressed: () {
                      controller.submitAbsence();
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
