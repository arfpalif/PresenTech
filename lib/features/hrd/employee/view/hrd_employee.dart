import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
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
        title: Text('HRD Employee Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                  if (employeeC.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  if (employeeC.employees.isEmpty) {
                    return Text("Belum ada karyawan");
                  }
                  return ListView.builder(
                    itemCount: employeeC.employees.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final t = employeeC.employees[index];
                      return Card(
                        shadowColor: Colors.transparent,
                        color: AppColors.greyprimary,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
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