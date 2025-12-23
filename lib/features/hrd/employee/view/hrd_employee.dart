import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/employee/view/hrd_employee_detail.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdEmployee extends StatefulWidget {
  const HrdEmployee({super.key});

  @override
  State<HrdEmployee> createState() => _HrdEmployeeState();
}

class _HrdEmployeeState extends State<HrdEmployee> {
  final employeeC = Get.put(HrdEmployeeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HRD Employee Page',
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: employeeC.searchEmployee,
                decoration: InputDecoration(
                  hintText: "Cari karyawan...",
                  hintStyle: AppTextStyle.normal.copyWith(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: AppColors.greyprimary),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: double.maxFinite,
                child: Obx(() {
                  if (employeeC.filteredEmployees.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Karyawan tidak ditemukan"),
                    );
                  }
                  return ListView.builder(
                    itemCount: employeeC.filteredEmployees.length,
                    itemBuilder: (_, i) {
                      final t = employeeC.filteredEmployees[i];
                      return Card(
                        shadowColor: Colors.transparent,
                        color: AppColors.greyprimary,
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(t.profilePicture),
                          ),
                          title: Text(
                            t.name,
                            style: AppTextStyle.heading2.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            t.role,
                            style: AppTextStyle.normal.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            Get.to(HrdEmployeeDetail(), arguments: t);
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              ElevatedButton(onPressed: () {}, child: Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }
}
