import 'package:get/get.dart';
import 'package:presentech/features/hrd/homepage/repositories/hrd_homepage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdHomepageController extends GetxController {
  final supabase = Supabase.instance.client;
  final homeRepo = HrdHomepageRepository();

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  var name = "".obs;
  var profilePic = "".obs;
  var role = "".obs;

  Future<void> getUser() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return;
      }

      final response = await homeRepo.getUserProfile(userId);

      profilePic.value = response['profile_picture'] ?? '';
      name.value = response['name'] ?? '';
      role.value = response['role'] ?? '';
    } catch (e) {
      throw ('Error fetching HRD homepage data: $e');
    }
  }
}
