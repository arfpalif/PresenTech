import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/auth/controller/auth_controller.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
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
  void signOut() async {
    await authC.signOut();
    Get.offAll(const Loginpage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Alif"),
              Obx(() {
                if (attendaceC.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (attendaceC.absences.isEmpty) {
                  return Text("Belum ada absensi");
                }
                return ListView.builder(
                  itemCount: attendaceC.absences.length,
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
              SizedBox(height: 10),
              AppGradientButton(text: "Logout", onPressed: signOut),
            ],
          ),
        ),
      ),
    );
  }
}
