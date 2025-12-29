import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class AbsenceList extends GetView<PresenceController> {
  AbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Absensi",
          style: AppTextStyle.heading1.copyWith(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Obx(
                    () => FilterChip(
                      label: Text("Today"),
                      selected:
                          controller.selectedFilter.value ==
                          AbsenceFilter.today,
                      onSelected: (bool value) {
                        controller.changeFilter(AbsenceFilter.today);
                        print("Hari ini");
                        print(controller.statusAbsen);
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This weeks"),
                      selected:
                          controller.selectedFilter.value == AbsenceFilter.week,
                      onSelected: (bool value) {
                        controller.changeFilter(AbsenceFilter.week);
                        print("Seminggu");
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This month"),
                      selected:
                          controller.selectedFilter.value ==
                          AbsenceFilter.month,
                      onSelected: (bool value) {
                        controller.changeFilter(AbsenceFilter.month);
                        print("Sebulan");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.absences.isEmpty) {
                  return const Text("Belum ada absensi");
                }

                return ListView.builder(
                  itemCount: controller.absences.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final t = controller.absences[index];
                    return Card(
                      shadowColor: Colors.transparent,
                      color: AppColors.greyprimary,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: StatusBadge(status: t.status),
                        title: Text(
                          DateFormat('dd-MM-yyyy').format(t.date),
                          style: AppTextStyle.heading2.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "Masuk : ${t.clockIn} | Keluar : ${t.clockOut}",
                          style: AppTextStyle.normal.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: ComponentBadgets(status: t.status),
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
