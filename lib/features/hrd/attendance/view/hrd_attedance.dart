import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdAttedance extends StatefulWidget {
  const HrdAttedance({super.key});

  @override
  State<HrdAttedance> createState() => _HrdAttedanceState();
}

class _HrdAttedanceState extends State<HrdAttedance> {
  final hrdAttedance = Get.put(HrdAttendanceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HRD Attendance")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Alif", style: AppTextStyle.heading1,),
                Obx(() {
                if (hrdAttedance.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (hrdAttedance.absences.isEmpty) {
                  return Text("Belum ada absensi");
                }
                return ListView.builder(
                  itemCount: hrdAttedance.absences.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = hrdAttedance.absences[index];
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
