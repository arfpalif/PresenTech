import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/features/employee/permissions/models/permission_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeePermissionController extends GetxController {
  final supabase = Supabase.instance.client;
  var filteredEmployees;
  var selectedFilter = Rxn<PermissionFilter>();

  Object? statusAbsen;

  RxBool isLoading = false.obs;

  RxList<Permission> permissions = <Permission>[].obs;
  @override
  void onInit() {
    super.onInit();
    getPermission();
  }

  Future<void> getPermission() async {
    final response = await supabase
        .from('permissions')
        .select()
        .order('created_at', ascending: false);

    permissions.assignAll(response.map((e) => Permission.fromJson(e)).toList());
  }

  Future<bool> insertPermission(Permission permission) async {
    final user = supabase.auth.currentSession?.user.id;
    if (user == null) {
      throw Exception("Error, user null");
    }

    final data = permission.toJson()..['user_id'] = user;
    try {
      await supabase.from('permissions').insert(data);
      await getPermission();
      return true;
    } catch (e) {
      debugPrint('Error inserting permission: $e');
      return false;
    }
  }

  void searchEmployee(String value) {}

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
}
