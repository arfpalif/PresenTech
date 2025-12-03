import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs; // Make the index observable with .obs

  void changePage(int index) {
    currentIndex.value = index;
  }
}
