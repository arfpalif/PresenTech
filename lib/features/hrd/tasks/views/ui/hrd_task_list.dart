import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/tasks/controller/hrd_task_controller.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdTaskList extends GetView<HrdTaskController> {
  const HrdTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tugas HRD',
          style: AppTextStyle.title.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.colorSecondary],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.tasks.isEmpty) {
              return const Text('Belum ada tugas');
            }

            return ListView.builder(
              itemCount: controller.tasks.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final t = controller.tasks[index];
                return Card(
                  shadowColor: Colors.transparent,
                  color: AppColors.greyprimary,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.hrdTaskDetail, arguments: t);
                    },
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      t.title,
                      style: AppTextStyle.heading2.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (t.userName != null)
                          Text(
                            'Pembuat: ${t.userName}',
                            style: AppTextStyle.normal.copyWith(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'Mulai: ${dateFormatter.format(t.startDate)} | Selesai: ${dateFormatter.format(t.endDate)}',
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Priority: ${t.priority}',
                          style: AppTextStyle.normal,
                        ),
                        Text('Level: ${t.level}', style: AppTextStyle.normal),
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
}
