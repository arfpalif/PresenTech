import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/view/ui/employee_add_task.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

import 'package:presentech/features/employee/tasks/view/components/task_summary_card.dart';
import 'package:presentech/shared/view/widgets/task_card.dart';

class EmployeeTask extends GetView<EmployeeTaskController> {
  const EmployeeTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Tasks',
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
      floatingActionButton: OpenContainer(
        closedElevation: 6,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        closedColor: ColorStyle.greenPrimary,
        openColor: const Color(0xFFF5F7FA),
        transitionDuration: const Duration(milliseconds: 500),
        closedBuilder: (context, openContainer) => const SizedBox(
          height: 56,
          width: 56,
          child: Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
        openBuilder: (context, closeContainer) => EmployeeAddTask(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Obx(
                () => TaskSummaryCard(
                  tasksToday: controller.tasksToday,
                  overdueCount: controller.overdueTasksCount,
                  finishedCount: controller.completedTasksCount,
                  todoCount: controller.toDoProgressTasksCount,
                  onProgressCount: controller.inProgressTasksCount,
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Icon(
                          Icons.assignment_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No tasks available',
                          style: AppTextStyle.heading2.copyWith(
                            color: Colors.grey,
                          ),
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
                    return TaskCard(
                      task: t,
                      isOverdue: controller.isTaskOverdue(t),
                      onTap: () async {
                        final result = await Get.toNamed(
                          Routes.employeeTaskDetail,
                          arguments: t,
                        );
                        if (result == true) {
                          controller.fetchTasks();
                        }
                      },
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
