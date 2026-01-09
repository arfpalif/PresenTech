import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presentech/features/employee/profile/repositories/profile_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/users.dart';
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
  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();
  final Rx<File?> localImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      localImage.value = File(image.path);
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

      debugPrint('LOCAL IMAGE PATH: ${file.path}');
      debugPrint('LOCAL IMAGE SIZE: ${file.lengthSync()} bytes');
      return supabase.storage.from('avatars').getPublicUrl(filePath);
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<void> changeProfilePicture() async {
    if (localImage.value == null) return;

    final rawUrl = await uploadImageToSupabase(localImage.value!);
    if (rawUrl == null) return;

    final cacheBustedUrl = '$rawUrl?t=${DateTime.now().millisecondsSinceEpoch}';

    await profileRepo.updateProfileImage(cacheBustedUrl);
    profileImageUrl.value = cacheBustedUrl;

    localImage.value = null;
  }

  Future<void> getUser() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      final response = await profileRepo.getUserProfile(currentUser.id);
      user.value = Users.fromJson(response);
      nameController.text = user.value?.name ?? '';
      emailController.text = user.value?.email ?? '';
      profileImageUrl.value = user.value?.profilePicture ?? '';
      validateForm();
    }
  }

  void validateForm() {
    final hasImage =
        localImage.value != null || profileImageUrl.value.isNotEmpty;
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        hasImage) {
      isFormValid.value = true;
    } else {
      isFormValid.value = false;
    }
  }
}
