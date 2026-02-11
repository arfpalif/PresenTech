import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/shared/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdProfileController extends GetxController {
  //repository
  final profileRepo = ProfileRepository();

  //variables
  final AuthController authC = Get.find<AuthController>();
  final supabase = Supabase.instance.client;
  final profilePic = "".obs;
  final profilePicLocal = "".obs;
  final name = "".obs;
  final role = "".obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<void> getUser() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return;
      }

      final response = await profileRepo.getUserProfile(userId);

      profilePic.value = response['profile_picture'] ?? '';
      profilePicLocal.value = response['local_image_path'] ?? '';
      name.value = response['name'] ?? '';
      role.value = response['role'] ?? '';
    } catch (e) {
      debugPrint('Error fetching HRD profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() async {
    await authC.signOut();
    Get.offAllNamed(Routes.login);
  }
}
