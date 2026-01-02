import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/hrd/profile/repositories/hrd_profile_repository.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdProfileController extends GetxController {
  final AuthController authC = Get.find<AuthController>();
  final supabase = Supabase.instance.client;
  var profilePic = "".obs;
  var name = "".obs;
  var role = "".obs;
  var isLoading = false.obs;
  final profileRepo = HrdProfileRepository();

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

      final response = await profileRepo.getUser(userId);

      if (response != null) {
        profilePic.value = response['profile_picture'] ?? '';
        name.value = response['name'] ?? '';
        role.value = response['role'] ?? '';
      }
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
