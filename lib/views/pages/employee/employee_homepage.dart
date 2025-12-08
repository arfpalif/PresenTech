import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controllers/employee/employee_task_controller.dart';
import 'package:presentech/views/components/Gradient_btn.dart';
import 'package:presentech/views/pages/employee/employee_task.dart';
import 'package:presentech/views/themes/themes.dart';

class EmployeeHomepage extends StatefulWidget {
  const EmployeeHomepage({super.key});

  @override
  State<EmployeeHomepage> createState() => _EmployeeHomepageState();
}

class _EmployeeHomepageState extends State<EmployeeHomepage> {
  final employeeTaskController = Get.put(EmployeeTaskController());

  @override
  void initState() {
    super.initState();
    employeeTaskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("PT Venturo", style: AppTextStyle.heading1),
                subtitle: Text("text posisi", style: AppTextStyle.normal),
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.colorPrimary,
                        AppColors.colorSecondary,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Jadwal anda hari ini",
                                    style: AppTextStyle.heading1.copyWith(
                                      color: AppColors.greenPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.greenPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "08.00",
                                            style: AppTextStyle.heading2,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Text("—", style: AppTextStyle.heading2),
                                      const SizedBox(width: 16),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "16.00",
                                            style: AppTextStyle.heading1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Status anda hari ini : Sudah absen",
                                    style: AppTextStyle.normal.copyWith(
                                      color: AppColors.greenPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: AppGradientButtonGreen(
                            text: "Presensi masuk",
                            textStyle: AppTextStyle.heading2.copyWith(
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Menu", style: AppTextStyle.heading1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppGradientButton(text: "Izin", onPressed: () {}),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppGradientButtonGreen(
                      text: "Tambah tugas",
                      onPressed: () {
                        Get.to(EmployeeTask());
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tasks", style: AppTextStyle.heading1),
                  Text(
                    "View All",
                    style: AppTextStyle.normal.copyWith(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (employeeTaskController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (employeeTaskController.tasks.isEmpty) {
                  return Text("Belum ada task");
                }
                return ListView.builder(
                  itemCount: employeeTaskController.tasks.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = employeeTaskController.tasks[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: AppColors.greyprimary,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                t.acceptanceCriteria,
                                style: AppTextStyle.heading2.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                t.createdAt,
                                style: AppTextStyle.normal.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Riwayat absensi", style: AppTextStyle.heading1),
                  Text(
                    "View All",
                    style: AppTextStyle.normal.copyWith(
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Colors.transparent,
                    color: AppColors.greyprimary,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Data 1",
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Data",
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
