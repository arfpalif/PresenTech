import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/controllers/profile_controller.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/shared/view/components/buttons/gradient_btn.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/textFields/text_field_outlined.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[ColorStyle.colorPrimary, ColorStyle.greenPrimary],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyle.title.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Setup your account',
                      style: AppTextStyle.heading1.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Update your personal information below.',
                    style: AppTextStyle.normal.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Obx(
                        () => Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorStyle.greenPrimary,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: controller.localImage.value != null
                                ? FileImage(controller.localImage.value!)
                                : controller.profilePictureUrl.value.isNotEmpty
                                ? NetworkImage(controller.profilePictureUrl.value)
                                : null,
                            child:
                                (controller.localImage.value == null &&
                                    controller.profilePictureUrl.value.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[300],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: ColorStyle.greenPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Email Address",
                        style: AppTextStyle.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextFieldOutlined(
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailController,
                    onChanged: (value) => controller.validateForm(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: Icon(Icons.email_outlined),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorStyle.colorSecondary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    icon: Icon(Icons.email),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Full Name",
                        style: AppTextStyle.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextFieldOutlined(
                    keyboardType: TextInputType.text,
                    controller: controller.nameController,
                    onChanged: (value) => controller.validateForm(),
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: Icon(Icons.person_outline),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorStyle.colorSecondary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    icon: Icon(Icons.person),
                  ),
                  SizedBox(height: 30),
                  Obx(
                    () => (controller.isFormValid.value
                        ? AppGradientButton(
                            text: "Save Changes",
                            onPressed: () => controller.updateProfileData(),
                          )
                        : AppDeactivatedButton(
                            text: "Save Changes",
                            onPressed: () => FailedSnackbar.show(
                                "Please complete the form",
                              ),
                          )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
