import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';
import 'package:presentech/utils/enum/task_status.dart';

// ignore: must_be_immutable
class HrdTaskDetail extends GetView<HrdTaskController> {
  late final Tasks task;

  HrdTaskDetail({super.key}) {
    task = Get.arguments as Tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Detail Tugas",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Task Status'),
                  const SizedBox(height: 12),
                  Row(
                    children: TaskStatus.values.map((status) {
                      final isSelected = (task.status ?? TaskStatus.todo) == status;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _getStatusColor(status).withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? _getStatusColor(status)
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _getStatusIcon(status),
                                  color: isSelected
                                      ? _getStatusColor(status)
                                      : Colors.grey[400],
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  status.name.replaceAll('_', ' ').capitalizeFirst!,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.smallText.copyWith(
                                    color: isSelected
                                        ? _getStatusColor(status)
                                        : Colors.grey[500],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Task Information'),
                  const SizedBox(height: 16),
                  _buildReadOnlyField("Judul Tugas", task.title, Icons.task_alt),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          "Mulai",
                          "${task.startDate.day}-${task.startDate.month}-${task.startDate.year}",
                          Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildReadOnlyField(
                          "Selesai",
                          "${task.endDate.day}-${task.endDate.month}-${task.endDate.year}",
                          Icons.event,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          "Level",
                          task.level.capitalizeFirst!,
                          Icons.bar_chart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildReadOnlyField(
                          "Priority",
                          task.priority.capitalizeFirst!,
                          Icons.priority_high,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    "Acceptance Criteria",
                    task.acceptanceCriteria,
                    Icons.checklist,
                  ),
                  if (task.userName != null) ...[
                    const SizedBox(height: 16),
                    _buildReadOnlyField(
                      "Assigned To",
                      task.userName!,
                      Icons.person,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.normal.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.smallText.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFieldOutlined(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          icon: Icon(icon),
        ),
      ],
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.blue;
      case TaskStatus.on_progress:
        return Colors.orange;
      case TaskStatus.finished:
        return ColorStyle.greenPrimary;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.assignment_outlined;
      case TaskStatus.on_progress:
        return Icons.rotate_right_rounded;
      case TaskStatus.finished:
        return Icons.check_circle_outline_rounded;
    }
  }
}
