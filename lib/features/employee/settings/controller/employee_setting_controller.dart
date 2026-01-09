import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/employee/profile/repositories/profile_repository.dart';
import 'package:presentech/shared/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeSettingController extends GetxController {
  //repository
  final profileRepo = ProfileRepository();
  final authC = Get.find<AuthController>();

  final supabase = Supabase.instance.client;
  final Rx<User?> user = Rx<User?>(null);
  var isLoading = false.obs;
  var profilePictureUrl = ''.obs;
  var name = ''.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<void> getUser() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      final response = await profileRepo.getUserProfile(currentUser.id);
      user.value = User.fromJson(response);
      profilePictureUrl.value = response['profile_picture'] ?? '';
      name.value = response['name'] ?? '';
      role.value = response['role'] ?? '';
    }
  }

  Future<void> signOut() async {
    await authC.signOut();
    Get.offAllNamed(Routes.login);
  }
}
