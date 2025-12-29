import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_detail_controller.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/view/components/Gradient_btn.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/themes/themes.dart';

class HrdEmployeeDetail extends GetView<HrdEmployeeDetailController> {
  final t = Get.arguments;
  bool isEdit = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  int? userId;

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
              Text("Lokasi Kantor", style: AppTextStyle.heading2),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoadingOffices.value) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.offices.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Belum ada lokasi kantor tersedia",
                      style: AppTextStyle.normal.copyWith(color: Colors.grey),
                    ),
                  );
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Office>(
                      isExpanded: true,
                      value: controller.selectedOffice.value,
                      hint: Text(
                        "Pilih Lokasi Kantor",
                        style: AppTextStyle.normal,
                      ),
                      items: controller.offices.map((Office office) {
                        return DropdownMenuItem<Office>(
                          value: office,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                office.name,
                                style: AppTextStyle.normal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                office.address,
                                style: AppTextStyle.normal.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (Office? newValue) {
                        if (newValue != null) {
                          controller.selectedOffice.value = newValue;
                        }
                      },
                    ),
                  ),
                );
              }),
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
                  // Validasi office dipilih
                  if (controller.selectedOffice.value == null) {
                    Get.snackbar(
                      "Error",
                      "Silakan pilih lokasi kantor",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final success = await controller.updateEmployee(
                    nameController.text,
                    emailController.text,
                    controller.selectedOffice.value!.id,
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
                if (controller.absences.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Tidak ada riwayat absensi"),
                  );
                }
                return ListView.builder(
                  itemCount: controller.absences.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final t = controller.absences[index];
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
                              "Masuk : ${t.clockIn != null && t.clockIn.isNotEmpty ? t.clockIn.substring(0, 5) : '-'} | Keluar : ${t.clockOut != null && t.clockOut.isNotEmpty ? t.clockOut.substring(0, 5) : '-'}",
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
