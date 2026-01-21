import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/absence/views/components/absence_list.dart';
import 'package:presentech/shared/styles/color_style.dart';

class AbsenceSummary extends GetView<PresenceController> {
  const AbsenceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ringkasan Bulan Ini",
            style: AppTextStyle.heading2.copyWith(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildSummaryItem(
                label: "Hadir",
                value: controller.hadir.toString(),
                color: ColorStyle.greenPrimary,
                icon: Icons.check_circle_outline_rounded,
              ),
              _buildSummaryItem(
                label: "Telat",
                value: controller.telat.toString(),
                color: ColorStyle.yellowPrimary,
                icon: Icons.access_time_rounded,
              ),
              _buildSummaryItem(
                label: "Alfa",
                value: controller.alfa.toString(),
                color: ColorStyle.redPrimary,
                icon: Icons.cancel_outlined,
              ),
              _buildSummaryItem(
                label: "Izin",
                value: controller.izin.toString(),
                color: ColorStyle.colorPrimary,
                icon: Icons.info_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Detail Absensi",
            style: AppTextStyle.heading2.copyWith(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          const AbsenceList(),
        ],
      );
    });
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Text(
                value,
                style: AppTextStyle.heading1.copyWith(
                  color: color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: AppTextStyle.smallText.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
