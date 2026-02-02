import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';

class CardAbsence extends StatelessWidget {
  CardAbsence({super.key});
  final PresenceController controller = Get.find<PresenceController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorStyle.colorPrimary,
                  ColorStyle.colorPrimary.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Jadwal Hari Ini",
                      style: AppTextStyle.heading2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.statusAbsen.value,
                          style: AppTextStyle.smallText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTimeInfo(
                      label: "Masuk",
                      time: "08:00",
                      icon: Icons.login_rounded,
                      color: ColorStyle.greenPrimary,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    _buildTimeInfo(
                      label: "Pulang",
                      time: "16:00",
                      icon: Icons.logout_rounded,
                      color: ColorStyle.redPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() {
                  if (controller.clockIn.value == false) {
                    return AppGradientButtonGreen(
                      text: "Clock In Sekarang",
                      onPressed: () => controller.submitAbsence(),
                    );
                  }
                  if (controller.clockOut.value == false) {
                    return AppGradientButtonRed(
                      text: "Clock Out Sekarang",
                      onPressed: () => controller.submitAbsence(),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: ColorStyle.greenPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorStyle.greenPrimary.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Presensi Hari Ini Selesai",
                        style: AppTextStyle.normal.copyWith(
                          color: ColorStyle.greenPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.smallText.copyWith(color: Colors.grey[600]),
              ),
              Text(
                time,
                style: AppTextStyle.heading1.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
