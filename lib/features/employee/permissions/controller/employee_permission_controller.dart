import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/repositories/permission_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeePermissionController extends GetxController {
  //repository
  final permissionRepo = PermissionRepository();

  //controllers
  final permissionTitleController = TextEditingController();

  final Rx<PermissionType?> selectedType = Rx<PermissionType?>(null);

  //supabase client
  final supabase = Supabase.instance.client;

  //variables
  var filteredEmployees = ''.obs;

  var selectedFilter = Rxn<PermissionFilter>();
  late final DateController dateController;
  Object? statusAbsen;

  RxBool isLoading = false.obs;

  RxList<Permission> permissions = <Permission>[].obs;
  @override
  void onInit() {
    super.onInit();
    getPermission();
    dateController = Get.find<DateController>();
  }

  Future<void> getPermission() async {
    final response = await permissionRepo.getPermissions();
    permissions.assignAll(response);
  }

  Future<bool> insertPermission(Permission permission) async {
    final user = supabase.auth.currentSession?.user.id;
    if (user == null) {
      throw Exception("Error, user null");
    }

    final data = permission.toJson()..['user_id'] = user;
    try {
      await permissionRepo.insertPermission(permission, user, data);
      await getPermission();
      return true;
    } catch (e) {
      debugPrint('Error inserting permission: $e');
      return false;
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
        final response = await permissionRepo.getPermissions();
        permissions.assignAll(response);

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

      final response = await supabase
          .from('permissions')
          .select()
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', now.toIso8601String())
          .order('created_at', ascending: false);

      final data = (response as List)
          .map((e) => Permission.fromJson(e))
          .toList();

      permissions.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  void submitForm() async {
    if (permissionTitleController.text.isEmpty ||
        dateController.startDateController.text.isEmpty ||
        dateController.endDateController.text.isEmpty ||
        selectedType.value == null) {
      Get.snackbar("Error", "Harap isi semua field");
      return;
    }

    DateTime? parseDate(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final y = int.parse(parts[2]);
        return DateTime(y, m, d);
      } catch (_) {
        return null;
      }
    }

    final start = parseDate(dateController.startDateController.text);
    final end = parseDate(dateController.endDateController.text);

    if (start == null || end == null) {
      Get.snackbar("Error", "Format tanggal tidak valid");
      return;
    }

    final newPermission = Permission(
      createdAt: DateTime.now(),
      startDate: start,
      endDate: end,
      type: selectedType.value!,
      reason: permissionTitleController.text,
    );

    final success = await insertPermission(newPermission);

    if (success) {
      await getPermission();
      Get.back();
      Get.snackbar("Success", "Permission berhasil ditambahkan");
    } else {
      Get.snackbar("Error", "Gagal menambahkan Permission");
    }
  }
}
