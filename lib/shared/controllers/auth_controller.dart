import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/shared/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final authRepo = AuthRepository();

  var isLoading = true.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> signOut() async {
    await authRepo.signOut();
    Get.offAllNamed(Routes.login);
  }
}
