import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  var profilePic = "".obs;
  var name = "".obs;
  var role = "".obs;
  var isLoading = false.obs;

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

      final response = await supabase
          .from('users')
          .select('name, profile_picture, role')
          .eq('id', userId)
          .maybeSingle();

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
}
