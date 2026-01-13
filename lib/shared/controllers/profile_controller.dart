import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/utils/services/image_picker_service.dart';
import 'package:presentech/features/employee/profile/repositories/profile_repository.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/users.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  //Repository
  final profileRepo = ProfileRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final DateController dateController = Get.find<DateController>();
  RxBool isFormValid = false.obs;

  //Variables
  final RxBool isEditing = false.obs;
  final Rx<Users?> user = Rx<Users?>(null);

  final photoProfile = ''.obs;
  final RxString name = ''.obs;
  final supabase = Supabase.instance.client;
  final ImagePickerService _imagePickerService = Get.find<ImagePickerService>();
  final Rx<File?> localImage = Rx<File?>(null);
  final RxString profilePictureUrl = ''.obs;
  final RxString role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<void> signOut() async {
    final authC = Get.find<AuthController>();
    await authC.signOut();
  }

  Future<void> getUser() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      final response = await profileRepo.getUserProfile(currentUser.id);
      user.value = Users.fromJson(response);
      nameController.text = user.value?.name ?? '';
      emailController.text = user.value?.email ?? '';
      profilePictureUrl.value = user.value?.profilePicture ?? '';
      role.value = user.value?.role ?? '';
      name.value = user.value?.name ?? '';
      validateForm();
    }
  }

  Future<void> pickImage() async {
    final croppedFile = await _imagePickerService.pickAndCropImage(
      ratioX: 1,
      ratioY: 1,
    );

    if (croppedFile != null) {
      localImage.value = croppedFile;
      validateForm();
    }
  }

  Future<String?> uploadImageToSupabase(File file) async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return null;

    try {
      final filePath = 'profile-${authUser.id}.jpg';

      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );
      return supabase.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<void> updateProfileData() async {
    try {
      String? imageUrl;
      if (localImage.value != null) {
        final rawUrl = await uploadImageToSupabase(localImage.value!);
        if (rawUrl != null) {
          imageUrl = '$rawUrl?t=${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      await profileRepo.updateProfile(
        name: nameController.text,
        imageUrl: imageUrl,
      );
      await getUser();
      localImage.value = null;
      SuccessSnackbar.show('Profile updated successfully.');
    } catch (e) {
      debugPrint('Update error: $e');
    }
  }

  void validateForm() {
    final hasImage =
        localImage.value != null || profilePictureUrl.value.isNotEmpty;
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        hasImage) {
      isFormValid.value = true;
    } else {
      isFormValid.value = false;
    }
  }
}
