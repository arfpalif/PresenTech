import 'package:flutter/material.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/configs/themes/themes.dart';

class TaskSummaryCard extends StatelessWidget {
  final List<Tasks> tasksToday;
  final int overdueCount;
  final int finishedCount;
  final int todoCount;
  final int onProgressCount;
  const TaskSummaryCard({
    super.key,
    required this.tasksToday,
    required this.overdueCount,
    required this.finishedCount,
    required this.todoCount,
    required this.onProgressCount,
  });

  @override
  Widget build(BuildContext context) {
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
                      "${todoCount + onProgressCount} Tugas Aktif",
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
                  textStatItem(
                    "To Do",
                    todoCount.toString(),
                    ColorStyle.colorPrimary,
                  ),
                  divider(),
                  textStatItem(
                    "On Progress",
                    onProgressCount.toString(),
                    ColorStyle.yellowPrimary,
                  ),
                  divider(),
                  textStatItem(
                    "Finished",
                    finishedCount.toString(),
                    ColorStyle.greenPrimary,
                  ),
                  divider(),
                  textStatItem(
                    "Overdue",
                    overdueCount.toString(),
                    ColorStyle.redPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget textStatItem(String label, String value, Color color) {
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

  Widget divider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }
}
