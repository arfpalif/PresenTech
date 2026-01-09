import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class EmployeeTask extends GetView<EmployeeTaskController> {
  const EmployeeTask({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: AppTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: ColorStyle.greenPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Get.toNamed(Routes.employeeTaskAdd);
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
                    SizedBox(height: 16),
                    Text(
                      'No tasks available',
                      style: AppTextStyle.heading2.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.tasks.length,
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
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                '${dateFormatter.format(t.startDate)} - ${dateFormatter.format(t.endDate)}',
                                style: AppTextStyle.smallText.copyWith(color: Colors.grey[600]),
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
                        _buildBadge(t.priority, _getPriorityColor(t.priority)),
                        SizedBox(height: 4),
                        Text('Level: ${t.level}', style: AppTextStyle.smallText.copyWith(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
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
        style: AppTextStyle.smallText.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
