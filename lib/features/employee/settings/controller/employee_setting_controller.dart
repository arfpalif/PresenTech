import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:presentech/features/employee/settings/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeSettingController extends GetxController {
  final supabase = Supabase.instance.client;
  final Rx<UserProfile?> user = Rx<UserProfile?>(null);
  var isLoading = false.obs;
  var profilePictureUrl = ''.obs;
  var name = ''.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();
      user.value = UserProfile.fromJson(response);
      profilePictureUrl.value = response['profile_picture'] ?? '';
      name.value = response['name'] ?? '';
      role.value = response['role'] ?? '';
    }
  }

  Future<void> signOut() async {
    final authController = AuthController();
    await authController.signOut();
    Get.offAllNamed(Routes.login);
  }
}
