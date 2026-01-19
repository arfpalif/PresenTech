import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/attendance/controller/hrd_attendance_controller.dart';
import 'package:presentech/features/hrd/attendance/view/components/filter_change.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/view/widgets/app_header.dart';

class HrdAttedance extends GetView<HrdAttendanceController> {
  const HrdAttedance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee attendance',
          style: AppTextStyle.heading1.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: const AppHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FilterChangeAttendance(),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.absences.isEmpty) {
                  return const Center(child: Text("Belum ada absensi"));
                }
                return ListView.builder(
                  itemCount: controller.absences.length,
                  itemBuilder: (_, index) {
                    final t = controller.absences[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: ColorStyle.greyprimary,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: StatusBadge(status: t.status),
                            title: Text(
                              t.userName ?? "No Name",
                              style: AppTextStyle.heading2.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Tanggal: ${DateFormat('dd-MM-yyyy').format(t.date)} \n Masuk : ${(t.clockIn != null && t.clockIn!.length >= 5) ? t.clockIn?.substring(0, 5) : (t.clockIn ?? '-')} | Keluar : ${(t.clockOut != null && t.clockOut!.length >= 5) ? t.clockOut?.substring(0, 5) : (t.clockOut ?? '-')}",
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
            ),
          ],
        ),
      ),
    );
  }
}
