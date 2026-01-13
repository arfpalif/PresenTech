import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/hrd/permission/repositories/hrd_permission_repository.dart';
import 'package:presentech/shared/models/permission.dart';

class HrdPermissionController extends GetxController {
  //repository
  final permissionRepo = HrdPermissionRepository();

  //variables
  var isLoading = false.obs;
  var name = ''.obs;
  var reason = ''.obs;
  var date = ''.obs;
  var status = ''.obs;
  var filteredEmployees = ''.obs;

  final RxList<Permission> permissions = <Permission>[].obs;
  final selectedFilter = Rxn<PermissionFilter>();

  @override
  void onInit() {
    super.onInit();
    fetchPermissions();
  }

  Future<void> fetchPermissions() async {
    try {
      final response = await permissionRepo.fetchPermissions();

      permissions.assignAll(
        response.map((e) => Permission.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show('Failed to fetch permissions');
    }
  }

  void changeFilter(PermissionFilter filter) {
    if (selectedFilter.value == filter) {
      selectedFilter.value = null;
    } else {
      selectedFilter.value = filter;
    }
    fetchPermissionsByDay();
  }

  Future<void> fetchPermissionsByDay() async {
    try {
      isLoading.value = true;

      final now = DateTime.now();

      if (selectedFilter.value == null) {
        final response = await permissionRepo.fetchPermissions();

        final data = (response as List)
            .map((e) => Permission.fromJson(e))
            .toList();

        permissions.assignAll(data);
        return;
      }

      late DateTime startDate;

      switch (selectedFilter.value!) {
        case PermissionFilter.today:
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case PermissionFilter.week:
          startDate = now.subtract(const Duration(days: 7));
          break;
        case PermissionFilter.month:
          startDate = DateTime(now.year, now.month, 1);
          break;
      }

      final response = await permissionRepo.fetchPermissionsByDateRange(
        startDate,
        now,
      );

      final data = (response as List)
          .map((e) => Permission.fromJson(e))
          .toList();

      permissions.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approvePermission(int permissionId) async {
    try {
      await permissionRepo.approvePermission(permissionId);
      SuccessDialog.show("Success", "Sukses menyetujui", () {});
      fetchPermissionsByDay();
    } catch (e) {
      FailedSnackbar.show('Failed to approve permission');
    }
  }

  Future<void> rejectPermission(int permissionId, String feedback) async {
    try {
      await permissionRepo.rejectPermission(permissionId, feedback);

      fetchPermissionsByDay();
      permissions.removeWhere((p) => p.id == permissionId);
    } catch (e) {
      FailedSnackbar.show('Failed to reject permission');
    }
  }
}
