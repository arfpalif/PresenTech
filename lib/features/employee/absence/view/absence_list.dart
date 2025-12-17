import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/controller/presence_controller.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class AbsenceList extends StatefulWidget {
  const AbsenceList({super.key});

  @override
  State<AbsenceList> createState() => _AbsenceListState();
}

class _AbsenceListState extends State<AbsenceList> {
  final PresenceController pc = Get.put(PresenceController());
  bool isSelectedWeek = false;
  bool isSelectedToday = false;
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
                      selected: pc.selectedFilter.value == AbsenceFilter.today,
                      onSelected: (bool value) {
                        pc.changeFilter(AbsenceFilter.today);
                        print("Hari ini");
                        print(pc.statusAbsen);
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This weeks"),
                      selected: pc.selectedFilter.value == AbsenceFilter.week,
                      onSelected: (bool value) {
                        pc.changeFilter(AbsenceFilter.week);
                        print("Seminggu");
                      },
                    ),
                  ),
                  Obx(
                    () => FilterChip(
                      label: Text("This month"),
                      selected: pc.selectedFilter.value == AbsenceFilter.month,
                      onSelected: (bool value) {
                        pc.changeFilter(AbsenceFilter.month);
                        print("Sebulan");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (pc.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pc.absences.isEmpty) {
                  return const Text("Belum ada absensi");
                }

                return ListView.builder(
                  itemCount: pc.absences.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final t = pc.absences[index];
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
