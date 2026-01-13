import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';

class Menu extends StatelessWidget {
  Menu({super.key});

  final NavigationController navController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text("Quick Actions", style: AppTextStyle.heading1),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMenuItem(
              icon: Icons.person_rounded,
              label: "Absensi",
              colors: [ColorStyle.greenPrimary, ColorStyle.greenSecondary],
              onTap: () => Get.toNamed(Routes.employeeAbsenceHistory),
            ),
            _buildMenuItem(
              icon: Icons.assignment_rounded,
              label: "Permission",
              colors: [
                ColorStyle.colorPrimary,
                ColorStyle.colorSecondary,
              ],
              onTap: () => navController.changePage(1),
            ),
            _buildMenuItem(
              icon: Icons.location_on_rounded,
              label: "Location",
              colors: [ColorStyle.yellowPrimary, ColorStyle.yellowSecondary],
              onTap: () => Get.to(ComingSoon()),
            ),
            _buildMenuItem(
              icon: Icons.task_rounded,
              label: "Tasks",
              colors: [ColorStyle.redPrimary, ColorStyle.redSecondary],
              onTap: () => navController.changePage(2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.smallText.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
