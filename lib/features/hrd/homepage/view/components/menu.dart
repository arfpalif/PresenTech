import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();
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
              icon: Icons.people_rounded,
              label: "Employees",
              colors: [ColorStyle.greenPrimary, ColorStyle.greenSecondary],
              onTap: () => navController.changePage(2),
            ),
            _buildMenuItem(
              icon: Icons.assignment_rounded,
              label: "Permission",
              colors: [ColorStyle.colorPrimary, ColorStyle.colorSecondary],
              onTap: () => navController.changePage(1),
            ),
            _buildMenuItem(
              icon: Icons.location_on_rounded,
              label: "Location",
              colors: [ColorStyle.yellowPrimary, ColorStyle.yellowSecondary],
              onTap: () => navController.changePage(3),
            ),
            _buildMenuItem(
              icon: Icons.task_rounded,
              label: "Tasks",
              colors: [ColorStyle.redPrimary, ColorStyle.redSecondary],
              onTap: () => Get.toNamed(Routes.hrdTask),
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
