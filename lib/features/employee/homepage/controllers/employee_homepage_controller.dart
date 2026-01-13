import 'package:get/get.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/employee/homepage/repositories/homepage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeHomepageController extends GetxController {
  // Repository
  final homePageRepo = HomepageRepository();

  final supabase = Supabase.instance.client;
  var name = "".obs;
  var profilePic = "".obs;
  var role = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Future<Map<String, dynamic>> getOffice() async {
    final session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      FailedSnackbar.show("User not login");
      throw Exception("Error");
    }

    final user = await homePageRepo.getUserOffice(session, userId);

    final officeId = user?['office_id'];

    if (user == null || officeId == null) {
      FailedSnackbar.show("User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }

    final office = await homePageRepo.getOfficeDetails(officeId);
    print("office row => $office");

    if (office == null) {
      FailedSnackbar.show("Tidak ada office");
      throw Exception("Error");
    }
    return office;
  }

  Future<void> getUser() async {
    final session = supabase.auth.currentUser;
    final userId = session?.id;

    try {
      if (userId == null) {
        FailedSnackbar.show("User not login");
        throw Exception("Error");
      }

      final response = await homePageRepo.getUser(session, userId);

      if (response == null) {
        throw Exception("Error");
      }

      name.value = response['name'];
      profilePic.value = response['profile_picture'];
      role.value = response['role'];
    } catch (e) {
      throw Exception(e);
    }
  }
}
