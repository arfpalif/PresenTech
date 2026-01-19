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

      permissions.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show('Failed to fetch permissions');
    }
  }

  List<Permission> get absenceToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return permissions.where((t) {
      final start = DateTime(
        t.startDate.year,
        t.startDate.month,
        t.startDate.day,
      );
      final end = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      return !start.isAfter(today) && !end.isBefore(today);
    }).toList();
  }

  List<Permission> get absenceWeekly {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    return permissions.where((t) {
      final start = DateTime(
        t.startDate.year,
        t.startDate.month,
        t.startDate.day,
      );
      final end = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      return !start.isAfter(today) && !end.isBefore(weekAgo);
    }).toList();
  }

  List<Permission> get absenceMonthly {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return permissions.where((t) {
      final start = DateTime(
        t.startDate.year,
        t.startDate.month,
        t.startDate.day,
      );
      final end = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);
      return !start.isAfter(today) && !end.isBefore(monthAgo);
    }).toList();
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

      final response = await permissionRepo.fetchPermissions();
      permissions.assignAll(response);

      if (selectedFilter.value != null) {
        switch (selectedFilter.value!) {
          case PermissionFilter.today:
            permissions.assignAll(absenceToday);
            break;
          case PermissionFilter.week:
            permissions.assignAll(absenceWeekly);
            break;
          case PermissionFilter.month:
            permissions.assignAll(absenceMonthly);
            break;
        }
      }
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
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
