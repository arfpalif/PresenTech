import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdHomepageController extends GetxController {
  final supabase = Supabase.instance.client;

  var name = "".obs;
  var profilePic = "".obs;
  var role = "".obs;

  Future<void> getUser() async {
    final session = supabase.auth.currentUser;
    final userId = session?.id;

    if (userId == null) {
      Get.snackbar("Error", "User not login");
      throw Exception("Error");
    }

    final response = await supabase
        .from("users")
        .select('name, profile_picture, role')
        .eq("id", userId)
        .maybeSingle();

    if (response == null) {
      throw Exception("Error");
    }

    print("user row => ${response['name']}");

    name.value = response['name'];
    profilePic.value = response['profile_picture'];
    role.value = response['role'];
  }
}
