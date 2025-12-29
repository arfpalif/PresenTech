import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class TaskListHomepage extends GetView<EmployeeTaskController> {
  TaskListHomepage({super.key});
  
  NavigationController get navController => Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tasks", style: AppTextStyle.heading1),
            GestureDetector(
              onTap: () {
                navController.changePage(2);
              },
              child: Text(
                "View All",
                style: AppTextStyle.normal.copyWith(
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.tasks.isEmpty) {
            return Text("Belum ada task");
          }
          return ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final t = controller.tasks[index];
              return Card(
                shadowColor: Colors.transparent,
                color: AppColors.greyprimary,
                margin: EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Get.toNamed(
                          Routes.employee_task_detail,
                          arguments: t,
                        );
                      },
                      title: Text(
                        t.title,
                        style: AppTextStyle.heading2.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        t.endDate.toString(),
                        style: AppTextStyle.normal.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
