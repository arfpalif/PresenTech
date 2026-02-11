import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/features/hrd/permission/controller/hrd_permission_detail_controller.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';
import 'package:presentech/shared/styles/input_style.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';

class HrdPermissionDetail extends GetView<HrdPermissionDetailController> {
  final Permission permission = Get.arguments as Permission;

  HrdPermissionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: permission.reason);
    final startDateController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(permission.startDate),
    );
    final endDateController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(permission.endDate),
    );
    final typeController = TextEditingController(
      text: permission.type == PermissionType.permission
          ? "Permission"
          : "Leave",
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Permission Detail',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: AppTextStyle.normal.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      ComponentBadgets(status: permission.status),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Permission Title',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFieldNormal(
                    controller: titleController,
                    readOnly: true,
                    decoration: AppInputStyle.decoration(icon: Icons.title),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Duration',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldNormal(
                          controller: startDateController,
                          readOnly: true,
                          decoration: AppInputStyle.decoration(
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("to", style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                        child: TextFieldNormal(
                          controller: endDateController,
                          readOnly: true,
                          decoration: AppInputStyle.decoration(
                            icon: Icons.event,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Type',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFieldNormal(
                    controller: typeController,
                    readOnly: true,
                    decoration: AppInputStyle.decoration(icon: Icons.category),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Submitted on',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFieldNormal(
                    controller: TextEditingController(
                      text: permission.createdAtYmd,
                    ),
                    readOnly: true,
                    decoration: AppInputStyle.decoration(
                      icon: Icons.access_time_filled,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Feedback',
                    style: AppTextStyle.normal.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFieldNormal(controller: controller.feedbackController),
                  if (permission.status == PermissionStatus.pending) ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: AppGradientButtonRed(
                            text: "Reject",
                            onPressed: () {
                              controller.rejectPermission(
                                permission.id!,
                                controller.feedbackController.text,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppGradientButtonGreen(
                            text: "Accept",
                            onPressed: () {
                              controller.approvePermission();
                            },
                          ),
                        ),
                      ],
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
}
