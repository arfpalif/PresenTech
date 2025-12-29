import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/controller/auth_controller.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/homepage/controller/hrd_homepage_controller.dart';
import 'package:presentech/shared/controllers/navigation_controller.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/features/auth/view/loginpage.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdHomepage extends StatefulWidget {
  const HrdHomepage({super.key});

  @override
  State<HrdHomepage> createState() => _HrdHomepageState();
}

class _HrdHomepageState extends State<HrdHomepage> {
  late final AuthController authC;
  late final HrdAttendanceController attendaceC;
  late final HrdHomepageController controller;
  late final NavigationController navController;

  @override
  void initState() {
    super.initState();
    authC = Get.find<AuthController>();
    attendaceC = Get.put(HrdAttendanceController());
    controller = Get.put(HrdHomepageController());
    navController = Get.find<NavigationController>();
    controller.getUser();
  }

  void signOut() async {
    await authC.signOut();
    Get.offAll(const Loginpage());
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
                              Get.toNamed(Routes.hrd_tasks);
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
                      Row(
                        children: [
                          Text(
                            "Rekap Absensi Karyawan",
                            style: AppTextStyle.heading1,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.HRD_ABSEN);
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
                                      "${DateFormat('dd-MM-yyyy').format(t.date)} | Masuk : ${t.clockIn != null && t.clockIn.isNotEmpty ? t.clockIn.substring(0, 5) : '-'} | Keluar : ${t.clockOut != null && t.clockOut.isNotEmpty ? t.clockOut.substring(0, 5) : '-'}",
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
  final controller = Get.find<HrdHomepageController>();
  final navController = Get.find<NavigationController>();
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
                        Get.toNamed(Routes.hrd_tasks);
                    },
                    child: Icon(Icons.help, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                        Get.toNamed(Routes.hrd_tasks);
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
  final attendaceC = Get.find<HrdAttendanceController>();
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
