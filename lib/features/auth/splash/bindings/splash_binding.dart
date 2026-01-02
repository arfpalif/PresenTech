import 'package:get/get.dart';
import 'package:presentech/features/auth/splash/controller/splash_controller.dart';
import 'package:presentech/features/auth/splash/repositories/splash_repository.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashRepository());
    Get.put(SplashController(Get.find<SplashRepository>()));
  }
}
