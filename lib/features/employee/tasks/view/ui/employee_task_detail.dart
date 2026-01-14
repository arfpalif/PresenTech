import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_detail_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';
import 'package:presentech/utils/enum/task_status.dart';

class EmployeeTaskDetail extends GetView<EmployeeTaskDetailController> {
  const EmployeeTaskDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Detail Tasks",
          style: AppTextStyle.title.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Get.back(result: controller.isChanged.value);
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                physics: const BouncingScrollPhysics(),
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
                              final isSelected = controller.selectedStatus.value == status;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: InkWell(
                                    onTap: () => controller.selectedStatus.value = status,
                                    borderRadius: BorderRadius.circular(12),
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
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            status.name.replaceAll('_', ' ').capitalizeFirst!,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.smallText.copyWith(
                                              color: isSelected
                                                  ? _getStatusColor(status)
                                                  : Colors.grey[600],
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
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Task Title'),
                          const SizedBox(height: 8),
                          TextFieldOutlined(
                            controller: controller.titleController,
                            decoration: _inputDecoration(
                              hint: "Enter task title",
                              icon: Icons.title,
                            ),
                            icon: const Icon(Icons.title),
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('Dates'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldOutlined(
                                  readOnly: true,
                                  controller: controller.dateController.startDateController,
                                  decoration: _inputDecoration(
                                    hint: "Start",
                                    icon: Icons.calendar_today,
                                  ),
                                  icon: const Icon(Icons.calendar_today),
                                  onTap: () => controller.dateController.pickStartDate(context),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFieldOutlined(
                                  readOnly: true,
                                  controller: controller.dateController.endDateController,
                                  decoration: _inputDecoration(
                                    hint: "End",
                                    icon: Icons.event,
                                  ),
                                  icon: const Icon(Icons.event),
                                  onTap: () => controller.dateController.pickEndDate(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Level'),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedLevel.value,
                                          hint: const Text("Select Level"),
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.grey,
                                          ),
                                          onChanged: (String? newValue) {
                                            controller.selectedLevel.value = newValue;
                                          },
                                          items: ["easy", "medium", "hard"].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value.capitalizeFirst!),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Priority'),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedPriority.value,
                                          hint: const Text("Select Priority"),
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.grey,
                                          ),
                                          onChanged: (String? newValue) {
                                            controller.selectedPriority.value = newValue;
                                          },
                                          items: ["high", "medium", "low"].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value.capitalizeFirst!),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('Acceptance Criteria'),
                          const SizedBox(height: 8),
                          TextFieldOutlined(
                            controller: controller.acceptanceController,
                            decoration: _inputDecoration(
                              hint: "Enter criteria",
                              icon: Icons.checklist_rtl,
                            ),
                            icon: const Icon(Icons.checklist),
                          ),
                          const SizedBox(height: 32),
                          AppGradientButton(
                            text: "Update Task",
                            onPressed: () {
                              controller.updateTask();
                            },
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                if (controller.task.id != null) {
                                  controller.deleteTask(controller.task.id!);
                                }
                              },
                              label: const Text(
                                "Delete Task",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorStyle.colorPrimary),
      ),
    );
  }
}
