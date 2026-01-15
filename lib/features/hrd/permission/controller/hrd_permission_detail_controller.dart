import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/permission/repositories/hrd_permission_repository.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/shared/view/components/snackbar/success_snackbar.dart';

class HrdPermissionDetailController extends GetxController {
  final permissionRepo = HrdPermissionRepository();

  late Permission permission;
  final feedbackController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxList<Permission> permissions = <Permission>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args == null) {
      Get.back();
      return;
    }
    permission = args as Permission;
    feedbackController.text = permission.feedback ?? '';
  }

  Future<void> fetchPermissions() async {
    try {
      final response = await permissionRepo.fetchPermissions();

      permissions.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show('Failed to fetch permissions');
    }
  }

  Future<void> approvePermission(int i) async {
    try {
      isLoading.value = true;
      await permissionRepo.approvePermission(permission.id!);
      SuccessSnackbar.show('Permission approved successfully');
      Get.back(result: true);
    } catch (e) {
      FailedSnackbar.show('Failed to approve permission');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectPermission(int id, String feedback) async {
    if (feedback.isEmpty) {
      FailedSnackbar.show('Please provide feedback for rejection');
      return;
    }

    try {
      isLoading.value = true;

      await permissionRepo.rejectPermission(id, feedbackController.text);

      await permissionRepo.fetchPermissions();

      SuccessDialog.show("Success", "Sukses mereject", () {
        Get.back(result: true);
      });
    } catch (e) {
      FailedSnackbar.show('Failed to reject permission');
    } finally {
      isLoading.value = false;
    }
  }
}
