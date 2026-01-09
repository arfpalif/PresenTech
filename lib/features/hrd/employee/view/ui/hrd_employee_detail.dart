import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_controller.dart';
import 'package:presentech/features/hrd/employee/controller/hrd_employee_detail_controller.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/models/users.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/components/textFields/text_field_normal.dart';
import 'package:presentech/shared/view/widgets/app_card.dart';
import 'package:presentech/shared/view/widgets/app_header.dart';
import 'package:presentech/configs/themes/themes.dart';

// ignore: must_be_immutable
class HrdEmployeeDetail extends GetView<HrdEmployeeDetailController> {
  bool isEdit = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  int? userId;

  late final Users employee;
  HrdEmployeeDetail({super.key}) {
    employee = Get.arguments as Users;
    nameController.text = employee.name;
    emailController.text = employee.email;
    roleController.text = employee.role;
    joinDateController.text = employee.createdAt != null
        ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(employee.createdAt!))
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Detail Karyawan',
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Image
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: Image.network(
                    employee.profilePicture ??
                        'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi Kontak",
                    style: AppTextStyle.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFieldNormal(
                    controller: nameController,
                    decoration: _inputDecoration(
                      label: "Nama",
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFieldNormal(
                    controller: emailController,
                    decoration: _inputDecoration(
                      label: "Email",
                      icon: Icons.email,
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),

                  TextFieldNormal(
                    controller: roleController,
                    decoration: _inputDecoration(
                      label: "Role",
                      icon: Icons.work,
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Lokasi Kantor",
                    style: AppTextStyle.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Obx(() {
                    if (controller.isLoadingOffices.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller.offices.isEmpty) {
                      return Text(
                        "Belum ada lokasi kantor tersedia",
                        style: AppTextStyle.normal.copyWith(color: Colors.grey),
                      );
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Office>(
                          isExpanded: true,
                          value: controller.selectedOffice.value,
                          hint: Text(
                            "Pilih Lokasi Kantor",
                            style: AppTextStyle.normal,
                          ),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                          items: controller.offices.map((Office office) {
                            return DropdownMenuItem<Office>(
                              value: office,
                              child: Text(
                                office.name,
                                style: AppTextStyle.normal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
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
                  const SizedBox(height: 16),

                  TextFieldNormal(
                    controller: joinDateController,
                    decoration: _inputDecoration(
                      label: "Tanggal Bergabung",
                      icon: Icons.calendar_today,
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),

                  AppGradientButton(
                    text: "Update Data",
                    onPressed: () async {
                      if (controller.selectedOffice.value == null) {
                        Get.snackbar(
                          "Perhatian",
                          "Silakan pilih lokasi kantor",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      final success = await controller.updateEmployee(
                        nameController.text,
                        emailController.text,
                        controller.selectedOffice.value!.id,
                      );
                      if (success) {
                        final mainController =
                            Get.find<HrdEmployeeController>();
                        await mainController.fetchEmployees();
                        Get.back();
                        Get.snackbar(
                          "Sukses",
                          "Data karyawan berhasil diperbarui",
                        );
                      } else {
                        Get.snackbar(
                          "Gagal",
                          "Terjadi kesalahan saat menyimpan data",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // History Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Riwayat Absensi",
                    style: AppTextStyle.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.absences.isEmpty) {
                    return Center(
                      child: Text(
                        "Tidak ada riwayat absensi",
                        style: AppTextStyle.normal.copyWith(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.absences.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final t = controller.absences[index];
                      return AppCard(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: StatusBadge(status: t.status),
                          title: Text(
                            DateFormat('EEEE, dd MMM yyyy').format(t.date),
                            style: AppTextStyle.heading2.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.login,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  t.clockIn?.substring(0, 5) ?? '-',
                                  style: AppTextStyle.normal.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.logout, size: 14, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  t.clockOut?.substring(0, 5) ?? '-',
                                  style: AppTextStyle.normal.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorStyle.colorPrimary),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.grey),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorStyle.colorPrimary),
    ),
  );
}
