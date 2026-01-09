import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/btn_right.dart';
import 'package:presentech/configs/themes/themes.dart';

class TaskListHomepage extends GetView<EmployeeTaskController> {
  const TaskListHomepage({super.key});

  NavigationController get navController => Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tasks", style: AppTextStyle.heading1),
                  GestureDetector(
                    onTap: () {
                      navController.changePage(2);
                    },
                    child: BtnRight(
                      text: "Lihat semua",
                      onPressed: () {
                        navController.changePage(2);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.tasks.isEmpty) {
                  return Text("Belum ada task");
                }
                return ListView.builder(
                  itemCount: 3 < controller.tasks.length
                      ? 3
                      : controller.tasks.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final t = controller.tasks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Routes.employeeTaskDetail, arguments: t);
                        },
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          t.title,
                          style: AppTextStyle.heading2.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${dateFormatter.format(t.startDate)} - ${dateFormatter.format(t.endDate)}',
                                    style: AppTextStyle.smallText.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBadge(
                              t.priority,
                              _getPriorityColor(t.priority),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Level: ${t.level}',
                              style: AppTextStyle.smallText.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return Colors.redAccent;
    case 'medium':
      return Colors.orangeAccent;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Widget _buildBadge(String text, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Text(
      text,
      style: AppTextStyle.smallText.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
