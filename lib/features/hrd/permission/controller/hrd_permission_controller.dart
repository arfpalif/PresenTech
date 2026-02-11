import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presentech/features/employee/absence/repositories/absence_repository.dart';
import 'package:presentech/utils/database/dao/permission_dao.dart';
import 'package:presentech/utils/enum/permission_filter.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/hrd/permission/repositories/hrd_permission_repository.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';
import 'package:presentech/utils/services/connectivity_service.dart';

class HrdPermissionController extends GetxController {
  //repository
  final permissionRepo = HrdPermissionRepository();
  final absenceRepo = AbsenceRepository();

  //connectivity service
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();

  //dao
  final PermissionDao permissionDao = Get.find<PermissionDao>();

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
    ever(connectivityService.isOnline, (bool isOnline) {
      if (isOnline) {
        fetchPermissions();
      }
    });
  }

  Future<void> fetchPermissions() async {
    try {
      final response = await permissionRepo.fetchPermissions();
      permissions.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show('Failed to fetch permissions');
    }
    if (permissions.isEmpty) {
      try {
        final localData = await permissionDao.getAllPermissions();
        permissions.assignAll(
          localData.map((e) => Permission.fromDrift(e)).toList(),
        );
      } catch (e) {
        debugPrint("Gagal fetch local (Permissions): $e");
        FailedSnackbar.show('Failed to fetch local permissions');
      }
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

      if (permissions.isEmpty) {
        final localData = await permissionDao.getAllPermissions();
        permissions.assignAll(
          localData.map((e) => Permission.fromDrift(e)).toList(),
        );

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
      }
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approvePermission(int permissionId) async {
    try {
      isLoading.value = true;
      final permission = permissions.firstWhere((p) => p.id == permissionId);

      await permissionRepo.approvePermission(
        permission.id!,
        permission.feedback,
      );

      if (permission.type == PermissionType.absence_error) {
        await absenceRepo.updateAbsenceStatus(
          userId: permission.userId!,
          date: DateFormat('yyyy-MM-dd').format(permission.startDate),
          status: AbsenceStatus.hadir.name,
          clockIn: DateFormat('HH:mm:ss').format(permission.createdAt),
        );
      } else if (permission.type == PermissionType.sick ||
          permission.type == PermissionType.leave ||
          permission.type == PermissionType.permission) {
        DateTime currentDate = permission.startDate;
        final DateTime endDate = permission.endDate;

        while (!currentDate.isAfter(endDate)) {
          await absenceRepo.updateAbsenceStatus(
            userId: permission.userId!,
            date: DateFormat('yyyy-MM-dd').format(currentDate),
            status: AbsenceStatus.izin.name,
          );
          currentDate = currentDate.add(const Duration(days: 1));
        }
      }
      SuccessDialog.show("Success", "Permission approved successfully", () {});
      Get.back(result: true);
      fetchPermissions();
    } catch (e) {
      debugPrint('Error approving permission: $e');
      FailedSnackbar.show('Failed to approve permission $e');
    } finally {
      isLoading.value = false;
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
