import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/tasks/view/components/task_summary_card.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/homepage/view/components/absence_list.dart';
import 'package:presentech/features/hrd/homepage/view/components/menu.dart';
import 'package:presentech/features/hrd/homepage/view/components/summary_card.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/controllers/profile_controller.dart';
import 'package:presentech/shared/view/ui/coming_soon.dart';
import 'package:presentech/shared/view/widgets/header.dart';

class HrdHomepage extends GetView<ProfileController> {
  const HrdHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<HrdTaskController>();
    Get.find<HrdAttendanceController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Column(
          children: [
            Obx(
              () => Header(
                height: 170,
                onComingSoonTap: () {
                  Get.to(ComingSoon());
                },
                imageUrl: controller.profilePictureUrl.value,
                localImagePath: controller.localImagePath.value,
                name: controller.name.value,
                role: controller.role.value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 0,
              ),
              child: Transform.translate(
                offset: Offset(0, -30),
                child: SummaryCard(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const Menu(),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rekap Tugas Karyawan",
                        style: AppTextStyle.heading1,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.hrdTask);
                      },
                      child: Obx(
                        () => TaskSummaryCard(
                          tasksToday: taskController.tasksToday,
                          overdueCount: taskController.overdueTasksCount,
                          finishedCount: taskController.completedTasksCount,
                          todoCount: taskController.toDoProgressTasksCount,
                          onProgressCount: taskController.inProgressTasksCount,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Column(
                      children: [
                        const AbsenceList(),
                        const SizedBox(height: 32),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
