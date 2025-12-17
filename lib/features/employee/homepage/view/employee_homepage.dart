import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/view/absence_list.dart';
import 'package:presentech/features/employee/homepage/controller/employee_homepage_controller.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/employee/tasks/controller/employee_task_controller.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/employee/tasks/view/employee_task.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class EmployeeHomepage extends StatefulWidget {
  const EmployeeHomepage({super.key});

  @override
  State<EmployeeHomepage> createState() => _EmployeeHomepageState();
}

class _EmployeeHomepageState extends State<EmployeeHomepage> {
  final controller = Get.put(EmployeeTaskController());
  final presenceController = Get.put(PresenceController());
  final homeController = Get.put(EmployeeHomepageController());
  final navController = Get.put(NavigationController());

  late String lat;
  late String long;
  var statusAbsen = "Status absen saat ini";
  var isAbsen = false;

  @override
  void initState() {
    super.initState();
    controller.fetchTasks();
    presenceController.checkTodayAbsence();
    presenceController.fetchAbsence();
    homeController.getUser();
    presenceController.checkTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Obx(
                      () => Text(
                        "Hi, ${homeController.name.value}",
                        style: AppTextStyle.heading1.copyWith(fontSize: 20),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navController.changePage(2);
                    },
                    child: Obx(() {
                      final imageUrl = homeController.profilePic.value;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imageUrl.isEmpty
                            ? CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.person),
                              )
                            : Image.network(
                                imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                      );
                    }),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text("PT Venturo", style: AppTextStyle.heading1),
                subtitle: Text("text posisi", style: AppTextStyle.normal),
              ),
              Card(
                margin: EdgeInsets.zero,
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
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Jadwal anda hari ini",
                                    style: AppTextStyle.normal.copyWith(
                                      color: AppColors.greenPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 10),
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
                                              color: AppColors.redPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "16.00",
                                            style: AppTextStyle.heading1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Obx(
                                    () => Text(
                                      presenceController.statusAbsen.value,
                                      style: AppTextStyle.normal.copyWith(
                                        color: AppColors.greenPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Obx(() {
                            if (presenceController.clockIn.value == false) {
                              return AppGradientButtonGreen(
                                text: "Presensi masuk",
                                onPressed: () {
                                  print(
                                    "clock in dipencet pada ${DateTime.now()}",
                                  );
                                  presenceController.absence();
                                },
                              );
                            }
                            if (presenceController.Clock_Out.value == false) {
                              return AppGradientButtonRed(
                                text: "Presensi keluar",
                                onPressed: () {
                                  presenceController.absence();
                                },
                              );
                            }
                            return AppGradientButtonGreen(
                              text: "Anda sudah absen, hari ini",
                              onPressed: () {
                                presenceController.clockInAbsence();
                              },
                            );
                          }),
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
                  Text("Riwayat absensi", style: AppTextStyle.heading1),
                  GestureDetector(
                    onTap: () {
                      Get.to(AbsenceList());
                    },
                    child: Text(
                      "View All",
                      style: AppTextStyle.normal.copyWith(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (presenceController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (presenceController.absences.isEmpty) {
                  return Text("Belum ada absensi");
                }
                return ListView.builder(
                  itemCount: presenceController.absences.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = presenceController.absences[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: AppColors.greyprimary,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: StatusBadge(status: t.status),
                            title: Text(
                              DateFormat('dd-MM-yyyy').format(t.date),
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Masuk : ${t.clockIn.toString()} keluar : ${t.clockOut.toString()}",
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            trailing: ComponentBadgets(status: t.status),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tasks", style: AppTextStyle.heading1),
                  Text(
                    "View All",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.tasks.isEmpty) {
                  return Text("Belum ada task");
                }
                return ListView.builder(
                  itemCount: controller.tasks.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = controller.tasks[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: AppColors.greyprimary,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Get.to(EmployeeTask(), arguments: t);
                            },
                            title: Text(
                              t.title,
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              t.endDate.toString(),
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppGradientButton(
                                text: "update",
                                onPressed: () {
                                  Get.to(EmployeeTask());
                                },
                              ),
                              SizedBox(width: 10),
                              AppGradientButtonGreen(
                                text: "Delete",
                                onPressed: () {
                                  controller.deleteTask(t.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
