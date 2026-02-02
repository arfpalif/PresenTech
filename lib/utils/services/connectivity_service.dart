import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      isOnline.value = false;
      print("Status: OFFLINE");
    } else {
      isOnline.value = true;
      print("Status: ONLINE");
    }
  }
}
