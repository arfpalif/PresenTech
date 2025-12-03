import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/controllers/auth_controller.dart';
import 'package:presentech/views/pages/loginpage.dart';
import 'package:presentech/views/themes/themes.dart';

class EmployeeHomepage extends StatefulWidget {
  const  EmployeeHomepage({super.key});

  @override
  State<EmployeeHomepage> createState() => _EmployeeHomepageState();
}

class _EmployeeHomepageState extends State<EmployeeHomepage> {
  final _authController = AuthController();

  void signOut() async{
    await _authController.signOut();
    Get.offAll(const Loginpage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text("PT Venturo", style: AppTextStyle.heading1),
              subtitle: Text("text posisi", style: AppTextStyle.normal),
            ),
            ElevatedButton(onPressed: (){
                signOut();
            }, child: Text("Sign Out")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.colorPrimary,
                        AppColors.colorSecondary,
                      ],
                    ),
                  ),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Jadwal anda hari ini",
                              style: AppTextStyle.heading1.copyWith(
                                color: AppColors.greenPrimary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenPrimary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.arrow_right_alt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text("08.00", style: AppTextStyle.heading2),
                                  ],
                                ),

                                const SizedBox(width: 16),

                                Text("—", style: AppTextStyle.heading2),

                                const SizedBox(width: 16),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_right_alt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text("16.00", style: AppTextStyle.heading1),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Status anda hari ini : Sudah absen",
                              style: AppTextStyle.normal.copyWith(
                                color: AppColors.greenPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Riwayat absensi", style: AppTextStyle.heading1),
                Text(
                  "View All",
                  style: AppTextStyle.normal.copyWith(
                    color: AppColors.colorPrimary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    shadowColor: Colors.transparent,
                    color: AppColors.greyprimary,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Data 1",
                              style: AppTextStyle.heading2.copyWith(color: Colors.black)
                            ),
                            subtitle: Text(
                              "Data",
                              style: AppTextStyle.normal.copyWith(color: Colors.grey)
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
