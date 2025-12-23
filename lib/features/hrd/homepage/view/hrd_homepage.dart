import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/auth/controller/auth_controller.dart';
import 'package:presentech/features/employee/homepage/controller/navigation_controller.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/homepage/controller/hrd_homepage_controller.dart';
import 'package:presentech/features/hrd/tasks/views/hrd_task.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/employee/auth/view/loginpage.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdHomepage extends StatefulWidget {
  const HrdHomepage({super.key});

  @override
  State<HrdHomepage> createState() => _HrdHomepageState();
}

class _HrdHomepageState extends State<HrdHomepage> {
  final authC = Get.find<AuthController>();
  final attendaceC = Get.put(HrdAttendanceController());
  final controller = Get.put(HrdHomepageController());
  final navController = Get.put(NavigationController());

  void signOut() async {
    await authC.signOut();
    Get.offAll(const Loginpage());
  }

  @override
  void initState() {
    super.initState();
    controller.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerSection(),
              attendanceSummaryCard(),

              Transform.translate(
                offset: const Offset(0, -50),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              navController.changePage(2);
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.colorPrimary,
                                        AppColors.colorSecondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Employees",
                                  style: AppTextStyle.smallText,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navController.changePage(1);
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.colorPrimary,
                                        AppColors.colorSecondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.email,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Permission",
                                  style: AppTextStyle.smallText,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navController.changePage(3);
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.colorPrimary,
                                        AppColors.colorSecondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text("Location", style: AppTextStyle.smallText),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(HrdTask());
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.colorPrimary,
                                        AppColors.colorSecondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.book,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text("Tasks", style: AppTextStyle.smallText),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Rekap Absensi Karyawan",
                        style: AppTextStyle.heading1,
                      ),
                      Obx(() {
                        if (attendaceC.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (attendaceC.absences.isEmpty) {
                          return Text("Belum ada absensi");
                        }
                        return ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            final t = attendaceC.absences[index];
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
                                      t.userName ?? 'Unknown user',
                                      style: AppTextStyle.heading2.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${DateFormat('dd-MM-yyyy').format(t.date)} | Masuk : ${t.clockIn.toString()} keluar : ${t.clockOut.toString()}",
                                      style: AppTextStyle.normal.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: ComponentBadgets(
                                      status: t.status,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                      SizedBox(height: 10),
                      AppGradientButton(text: "Logout", onPressed: signOut),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget headerSection() {
  final controller = Get.put(HrdHomepageController());
  final navController = Get.put(NavigationController());
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.colorPrimary, AppColors.colorSecondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
    ),
    child: Obx(() {
      return SafeArea(
        bottom: false,
        child: Container(
          height: 190,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Presentech",
                    style: AppTextStyle.title.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(HrdTask());
                    },
                    child: Icon(Icons.help, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(HrdTask());
                    },
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: GestureDetector(
                  onTap: () {
                    navController.changePage(2);
                  },
                  child: Obx(() {
                    final imageUrl = controller.profilePic.value;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageUrl.isEmpty
                          ? CircleAvatar(radius: 20, child: Icon(Icons.person))
                          : Image.network(
                              imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                    );
                  }),
                ),
                title: Text(
                  "Selamat Datang, ${controller.name.value} ",
                  style: AppTextStyle.heading1.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  controller.role.value,
                  style: AppTextStyle.normal.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}

Widget attendanceSummaryCard() {
  final attendaceC = Get.put(HrdAttendanceController());
  return Transform.translate(
    offset: const Offset(0, -50),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              summaryItem("Hadir\n ${attendaceC.hadir} 20"),
              summaryItem("telat\n2 ${attendaceC.telat}"),
              summaryItem("Alpha\n0 ${attendaceC.alfa}"),
            ],
          );
        }),
      ),
    ),
  );
}

Widget summaryItem(String label) {
  return Column(
    children: [
      Text(label, style: AppTextStyle.normal.copyWith(color: Colors.grey)),
      const SizedBox(height: 8),
    ],
  );
}
