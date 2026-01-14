import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/configs/themes/themes.dart';

class TaskSummaryCard extends GetView<EmployeeTaskController> {
  const TaskSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalToday = controller.tasksToday.length;
      final pendingToday = controller.tasksToday
          .where((t) => t.status?.name != 'finished')
          .length;
      final motivationText = _getMotivationText(pendingToday, totalToday);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorStyle.colorPrimary,
              ColorStyle.greenPrimary.withOpacity(0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ColorStyle.colorPrimary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, Focus Hari Ini",
                        style: AppTextStyle.smallText.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalToday Tugas Aktif",
                        style: AppTextStyle.title.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildStatItem(
                      "To Do",
                      controller.tasksToday
                          .where((t) => t.status?.name == 'todo')
                          .length
                          .toString(),
                      ColorStyle.colorPrimary,
                    ),
                    _buildDivider(),
                    _buildStatItem(
                      "On Progress",
                      controller.tasksToday
                          .where((t) => t.status?.name == 'on_progress')
                          .length
                          .toString(),
                      ColorStyle.yellowPrimary,
                    ),
                    _buildDivider(),
                    _buildStatItem(
                      "Finished",
                      controller.tasksToday
                          .where((t) => t.status?.name == 'finished')
                          .length
                          .toString(),
                      ColorStyle.greenPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.tips_and_updates_rounded,
                    color: ColorStyle.yellowPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      motivationText,
                      style: AppTextStyle.smallText.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyle.heading1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.smallText.copyWith(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }

  String _getMotivationText(int pending, int total) {
    if (total == 0)
      return "Belum ada tugas untuk hari ini. Luangkan waktu untuk merencanakan!";
    if (pending == 0)
      return "Luar biasa! Semua tugas hari ini telah selesai dikerjakan.";
    if (pending == 1)
      return "Hanya tinggal 1 tugas lagi! Ayo selesaikan sekarang.";
    return "Ada $pending tugas lagi yang menunggu. Semangat menyelesaikannya!";
  }
}
