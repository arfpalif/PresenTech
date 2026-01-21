import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/dropdowns/dropdown_field_normal.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';
import 'package:presentech/shared/styles/input_style.dart';

class EmployeeAddTask extends GetView<EmployeeTaskController> {
  const EmployeeAddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Add Task",
          style: AppTextStyle.heading1.copyWith(
            fontSize: 20,
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
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Task Title'),
                  TextFieldNormal(
                    controller: controller.titleController,
                    decoration: AppInputStyle.decoration(icon: Icons.title),
                  ),
                  SizedBox(height: 16),

                  _buildLabel('Duration'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldNormal(
                          controller:
                              controller.dateController.startDateController,
                          readOnly: true,
                          onTap: () =>
                              controller.dateController.pickStartDate(context),
                          decoration: AppInputStyle.decoration(
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("to", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        child: TextFieldNormal(
                          controller:
                              controller.dateController.endDateController,
                          readOnly: true,
                          onTap: () =>
                              controller.dateController.pickEndDate(context),
                          decoration: AppInputStyle.decoration(
                            icon: Icons.event,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Level'),
                            Obx(
                              () => DropdownFieldNormal<String>(
                                value: controller.selectedLevel.value,
                                items: const ["easy", "medium", "hard"],
                                onChanged: (val) =>
                                    controller.selectedLevel.value = val,
                                decoration: AppInputStyle.decoration(
                                  icon: Icons.layers_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Priority'),
                            Obx(
                              () => DropdownFieldNormal<String>(
                                value: controller.selectedPriority.value,
                                items: const ["low", "medium", "high"],
                                onChanged: (val) =>
                                    controller.selectedPriority.value = val,
                                decoration: AppInputStyle.decoration(
                                  icon: Icons.priority_high,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  _buildLabel('Acceptance Criteria'),
                  TextFieldNormal(
                    controller: controller.acceptanceController,
                    maxLines: 3,
                    decoration: AppInputStyle.decoration(
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            AppGradientButton(
              text: "Create Task",
              onPressed: controller.submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTextStyle.normal.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
