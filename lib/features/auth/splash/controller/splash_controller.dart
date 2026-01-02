import 'package:get/get.dart';
import 'package:presentech/configs/routes/app_routes.dart';
import 'package:presentech/features/auth/splash/repositories/splash_repository.dart';

class SplashController extends GetxController {
  final SplashRepository splashRepo;
  SplashController(this.splashRepo);

  @override
  onInit() {
    super.onInit();
    handleAuth();
  }

  Future<void> handleAuth() async {
    try {
      final session = await splashRepo.getSession();
      if (session == null) {
        Get.offAllNamed(Routes.login);
        return;
      }

      final role = await splashRepo.getRole(session.user.id);
      if (role == 'hrd') {
        Get.offAllNamed(Routes.hrdNavbar);
      } else {
        Get.offAllNamed(Routes.employeeNavbar);
      }
    } catch (e) {
      Get.offAllNamed(Routes.login);
    }
  }
}
