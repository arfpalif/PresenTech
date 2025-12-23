import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_detail_controller.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/components/component_badgets.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdEmployeeDetail extends StatefulWidget {
  const HrdEmployeeDetail({super.key});

  @override
  State<HrdEmployeeDetail> createState() => _HrdEmployeeDetailState();
}

class _HrdEmployeeDetailState extends State<HrdEmployeeDetail> {
  final employeeC = Get.put(HrdEmployeeDetailController());
  final t = Get.arguments;
  bool isEdit = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  int? userId;

  @override
  void initState() {
    super.initState();
    if (t != null) {
      isEdit = true;
    }
    if (isEdit) {
      nameController.text = t.name;
      emailController.text = t.email;
      roleController.text = t.role;
      joinDateController.text = t.createdAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HRD Employee Detail Page',
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    t.profilePicture,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Informasi kontak", style: AppTextStyle.heading1),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: nameController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintStyle: AppTextStyle.normal,
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: roleController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Role",
                  prefixIcon: Icon(Icons.grid_view),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: AppTextStyle.normal,
                keyboardType: TextInputType.text,
                controller: joinDateController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Tanggal bergabung",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              AppGradientButton(
                text: "Submit",
                onPressed: () async {
                  final success = await employeeC.updateEmployee(
                    nameController.text,
                    emailController.text,
                  );
                  if (success) {
                    final mainController = Get.find<HrdEmployeeController>();
                    await mainController.fetchEmployees();
                    Get.back();
                    Get.snackbar("Success", "Employee updated successfully");
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to update employee",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Text("Riwayat absensi", style: AppTextStyle.heading1),
              SizedBox(height: 10),
              Obx(() {
                if (employeeC.absences.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Tidak ada riwayat absensi"),
                  );
                }
                return ListView.builder(
                  itemCount: employeeC.absences.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = employeeC.absences[index];
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
    );
  }
}
