import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:presentech/features/hrd/permission/model/permission.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdPermissionController extends GetxController {
  // Tambahkan variabel dan metode yang diperlukan untuk mengelola izin di sini
  var isLoading = false.obs;
  var name = ''.obs;
  var reason = ''.obs;
  var date = ''.obs;
  var status = ''.obs;
  var filteredEmployees;

  var selectedFilter = Rxn<PermissionFilter>();
  final RxList<Permission> permissions = <Permission>[].obs;
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchPermissions();
  }

  Future<void> fetchPermissions() async {
    try {
      final response = await supabase
          .from('permissions')
          .select()
          .order('created_at', ascending: false);

      permissions.assignAll(
        response.map((e) => Permission.fromJson(e)).toList(),
      );
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      Get.snackbar('Error', 'Failed to fetch permissions');
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
        final response = await supabase
            .from('permissions')
            .select()
            .order('created_at', ascending: false);

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

  Future<void> approvePermission(int permissionId) async {
    try {
      await supabase
          .from('permissions')
          .update({'status': 'approved'})
          .eq('id', permissionId);

      fetchPermissionsByDay();
    } catch (e) {
      debugPrint('Error approving permission: $e');
      Get.snackbar('Error', 'Failed to approve permission');
    }
  }

  Future<void> rejectPermission(int permissionId) async {
    try {
      await supabase
          .from('permissions')
          .update({'status': 'rejected'})
          .eq('id', permissionId);

      fetchPermissionsByDay();
      permissions.remove((p) => p.id == permissionId);
    } catch (e) {
      debugPrint('Error rejecting permission: $e');
      Get.snackbar('Error', 'Failed to reject permission');
    }
  }
}
