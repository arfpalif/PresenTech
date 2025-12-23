import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../settings/model/user.dart';

class ProfileController extends GetxController {
  final RxBool isEditing = false.obs;
  final user = Get.arguments;
  final supabase = Supabase.instance.client;

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
    }
  }
}
