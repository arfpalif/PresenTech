import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/view/components/dialog/failed_dialog.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/employee/permissions/repositories/permission_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeePermissionController extends GetxController {
  // Repository
  final _permissionRepo = PermissionRepository();

  // Supabase
  final _supabase = Supabase.instance.client;
  String get _userId => _supabase.auth.currentUser?.id ?? "";

  // Controllers
  final permissionTitleController = TextEditingController();
  DateController get dateController => Get.find<DateController>();

  // Observables
  final selectedType = Rxn<PermissionType>();
  final selectedFilter = Rxn<PermissionFilter>();
  final isLoading = false.obs;
  final permissions = <Permission>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPermissions();
  }

  Future<void> fetchPermissions() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      DateTime? startDate;
      final now = DateTime.now();

      if (selectedFilter.value != null) {
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
      }

      final response = await _permissionRepo.getPermissions(
        _userId,
        startDate: startDate,
        endDate: now,
      );
      permissions.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show("Gagal mengambil data ijin");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelPermission(
    String permissionId,
    PermissionStatus status,
  ) async {
    if (status == PermissionStatus.cancelled) {
      FailedDialog.show(
        "Failed",
        "Permintaan ijin sudah dibatalkan sebelumnya",
        () {},
      );
      return;
    }
    try {
      isLoading.value = true;

      await _permissionRepo.updatePermission(int.parse(permissionId), {
        'status': PermissionStatus.cancelled.name,
      });

      await fetchPermissions();

      Get.back();

      SuccessDialog.show(
        "Success",
        "Permintaan ijin berhasil dibatalkan",
        () {},
      );
    } catch (e) {
      debugPrint('Error cancelling permission: $e');
      FailedSnackbar.show("Gagal membatalkan permintaan ijin");
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(PermissionFilter filter) {
    selectedFilter.value = (selectedFilter.value == filter) ? null : filter;
    fetchPermissions();
  }

  void submitForm() async {
    if (permissionTitleController.text.isEmpty ||
        dateController.startDateController.text.isEmpty ||
        dateController.endDateController.text.isEmpty ||
        selectedType.value == null) {
      FailedSnackbar.show("Harap isi semua field");
      return;
    }

    DateTime? parseDate(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {
        return null;
      }
    }

    final start = parseDate(dateController.startDateController.text);
    final end = parseDate(dateController.endDateController.text);

    if (start == null || end == null) {
      FailedSnackbar.show("Format tanggal tidak valid");
      return;
    }

    try {
      isLoading.value = true;
      final newPermission = Permission(
        createdAt: DateTime.now(),
        startDate: start,
        endDate: end,
        type: selectedType.value!,
        reason: permissionTitleController.text,
        status: PermissionStatus.pending,
      );

      final data = newPermission.toJson()..['user_id'] = _userId;
      await _permissionRepo.insertPermission(data);
      Get.back();
      await fetchPermissions();
      SuccessDialog.show("Success", "Permintaan ijin berhasil dikirim", () {});
    } catch (e) {
      debugPrint('Error submitting permission: $e');
      FailedSnackbar.show("Gagal mengirim permintaan ijin");
    } finally {
      isLoading.value = false;
    }
  }
}
