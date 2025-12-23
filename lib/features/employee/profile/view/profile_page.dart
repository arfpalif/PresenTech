import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/settings/model/user.dart';
import 'package:presentech/features/views/themes/themes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile user = Get.arguments as UserProfile;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                user.profilePicture?.isNotEmpty == true
                                    ? user.profilePicture
                                    : 'https://www.gravatar.com/avatar/?d=mp',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              user.name ?? 'Pengguna',
                              style: AppTextStyle.heading1,
                            ),
                            SizedBox(height: 10),
                            Text(
                              user.role ?? '-',
                              style: AppTextStyle.normal.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Informasi Personal", style: AppTextStyle.heading1),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: AppColors.colorPrimary),
                  ),
                  title: Text(
                    "Email",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    user.email ?? 'Email belum tersedia',
                    style: AppTextStyle.heading1,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.business, color: AppColors.colorPrimary),
                  ),
                  title: Text(
                    "Lokasi Kantor",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    "Jakarta, Indonesia",
                    style: AppTextStyle.heading1,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.date_range,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  title: Text(
                    "Tanggal bergabung",
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  subtitle: Text(
                    "1 Januari 2020",
                    style: AppTextStyle.heading1,
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1, height: 24),
                Text("Jadwal kerja", style: AppTextStyle.heading1),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.schedule, color: AppColors.colorPrimary),
                  ),
                  title: Text("Senin - Jumat", style: AppTextStyle.heading1),
                  subtitle: Text(
                    "09.00 - 17.00 WIB",
                    style: AppTextStyle.normal.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
