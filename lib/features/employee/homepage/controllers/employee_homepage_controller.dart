import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeHomepageController extends GetxController {
  final supabase = Supabase.instance.client;
  var name = "".obs;
  var profilePic = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<Map<String, dynamic>> getOffice() async {
    final session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      Get.snackbar("Error", "User not login");
      throw Exception("Error");
    }

    final user = await supabase
        .from("users")
        .select("office_id")
        .eq("id", userId)
        .maybeSingle();

    print("user row => $user");
    print("office id => ${user?['office_id']}");

    final officeId = user?['office_id'];

    if (user == null || officeId == null) {
      Get.snackbar("Error", "User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }

    final office = await supabase
        .from("offices")
        .select()
        .eq("id", officeId)
        .maybeSingle();
    print("office row => $office");

    if (office == null) {
      Get.snackbar("Error", "Tidak ada office");
      throw Exception("Error");
    }
    return office;
  }

  Future<void> getUser() async {
    final session = supabase.auth.currentUser;
    final userId = session?.id;

    if (userId == null) {
      Get.snackbar("Error", "User not login");
      throw Exception("Error");
    }

    final response = await supabase
        .from("users")
        .select('name, profile_picture')
        .eq("id", userId)
        .maybeSingle();

    if (response == null) {
      throw Exception("Error");
    }

    print("user row => ${response['name']}");

    name.value = response['name'];
    profilePic.value = response['profile_picture'];
  }
}
