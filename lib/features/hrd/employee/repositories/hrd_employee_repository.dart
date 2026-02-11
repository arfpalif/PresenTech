import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:presentech/utils/database/dao/hrd/user_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final UserDao userDao = Get.find<UserDao>();

  Future<List<Employee>> fetchEmployees() async {
    List<Employee> employees = [];
    try {
      final response = await supabase
          .from(ApiConstant.tableUsers)
          .select('*, offices(name)')
          .order('id', ascending: true);

      employees = (response as List).map((e) => Employee.fromJson(e)).toList();

      await userDao.syncEmployeesToLocal(
        employees.map((e) => e.toDrift()).toList(),
      );
      return employees;
    } catch (e) {
      debugPrint("Error fetching employees online, falling back to local: $e");
      final localData = await userDao.getAllEmployees();
      return localData.map((e) => Employee.fromDrift(e)).toList();
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserAbsences() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    try {
      final response = await supabase
          .from(ApiConstant.tableAbsences)
          .select()
          .eq('user_id', user.id);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching absences online: $e");
      return [];
    }
  }

  Future<bool> updateEmployee(
    String name,
    String email,
    int officeId,
    String userId,
  ) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from(ApiConstant.tableUsers)
          .update({'name': name, 'email': email, 'office_id': officeId})
          .eq('id', userId);
      fetchEmployees();
      return true;
    } catch (e) {
      debugPrint('Error updating employee: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOffices() async {
    try {
      final response = await supabase
          .from('offices')
          .select('*')
          .order('id', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching offices: $e');
      return [];
    }
  }
}
