import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presentech/shared/repositories/profile_repository.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/image_picker_service.dart';
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
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
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
  final RxString localImagePath = ''.obs;
  final RxString role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();

    ever(connectivityService.isOnline, (bool online) async {
      if (online) {
        debugPrint("ProfileController: Online detected, syncing profile...");
        await profileRepo.syncOfflineProfiles();
        await getUser();
      }
    });
  }

  Future<void> signOut() async {
    final authC = Get.find<AuthController>();
    await authC.signOut();
  }

  Future<void> getUser() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      try {
        final response = await profileRepo.getUserProfile(currentUser.id);
        user.value = Users.fromJson(response);
        nameController.text = user.value?.name ?? '';
        emailController.text = user.value?.email ?? '';
        profilePictureUrl.value = user.value?.profilePicture ?? '';
        role.value = user.value?.role ?? '';
        name.value = user.value?.name ?? '';

        final savedLocalPath = response['local_image_path'] as String?;
        if (savedLocalPath != null && savedLocalPath.isNotEmpty) {
          final file = File(savedLocalPath);
          if (await file.exists()) {
            localImage.value = file;
            localImagePath.value = savedLocalPath;
          }
        }

        validateForm();
      } catch (e) {
        debugPrint('Error getting user: $e');
      }
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

  /// Save image to local storage for persistent offline access
  Future<String> saveImageLocally(File file) async {
    final userId = supabase.auth.currentUser?.id ?? 'unknown';
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_$userId.jpg';
    final savedPath = '${appDir.path}/$fileName';

    // Copy file to app documents directory
    final savedFile = await file.copy(savedPath);
    print('Image saved locally: ${savedFile.path}');
    return savedFile.path;
  }

  Future<void> updateProfileData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      String? savedLocalPath;

      // 1. If user picked a new image, save it locally first
      if (localImage.value != null) {
        savedLocalPath = await saveImageLocally(localImage.value!);
        localImagePath.value = savedLocalPath;
      }

      // 2. Call repository to update (saves locally first, syncs in background if online)
      await profileRepo.updateProfile(
        name: nameController.text,
        localImagePath: savedLocalPath,
      );

      // 3. Refresh UI from local
      await getUser();

      if (connectivityService.isOnline.value) {
        SuccessSnackbar.show('Profile updated successfully.');
      } else {
        SuccessSnackbar.show('Profile saved offline. Will sync when online.');
      }
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
