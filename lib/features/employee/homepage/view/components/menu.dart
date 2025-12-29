import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class Menu extends StatelessWidget {
  Menu({super.key});

  final NavigationController navController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.employee_absence_history);
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.greenPrimary,
                          AppColors.greenSecondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person, size: 25, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Absensi", style: AppTextStyle.smallText),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navController.changePage(1);
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.colorPrimary,
                          AppColors.colorSecondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.email, size: 25, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Permission", style: AppTextStyle.smallText),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navController.changePage(3);
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.colorPrimary,
                          AppColors.colorSecondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Location", style: AppTextStyle.smallText),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navController.changePage(2);
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.colorPrimary,
                          AppColors.colorSecondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.book, size: 25, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Tasks", style: AppTextStyle.smallText),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
