import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Value;
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/utils/database/dao/hrd/user_dao.dart';
import 'package:presentech/utils/database/dao/location_dao.dart';
import 'package:presentech/utils/database/database.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final UserDao userDao = Get.find<UserDao>();
  final LocationDao locationDao = Get.find<LocationDao>();

  Future<List<Employee>> fetchEmployees() async {
    if (connectivityService.isOnline.value) {
      await syncOfflineEmployees();
    }

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

  Future<void> syncOfflineEmployees() async {
    try {
      final unsynced = await userDao.getUnsyncedEmployees();
      if (unsynced.isEmpty) return;

      for (var emp in unsynced) {
        if (emp.syncAction == 'update') {
          await supabase
              .from(ApiConstant.tableUsers)
              .update({
                'name': emp.name,
                'email': emp.email,
                'office_id': emp.officeId,
              })
              .eq('id', emp.userId);
          await userDao.markEmployeeAsSynced(emp.userId);
          debugPrint("Synced offline update for employee: ${emp.userId}");
        }
      }
    } catch (e) {
      debugPrint("Error syncing offline employees: $e");
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
      final companion = EmployeesTableCompanion(
        name: Value(name),
        email: Value(email),
        officeId: Value(officeId),
        isSynced: Value(0),
        syncAction: Value('update'),
      );
      await userDao.updateEmployeeData(userId, companion);

      if (connectivityService.isOnline.value) {
        await supabase
            .from(ApiConstant.tableUsers)
            .update({'name': name, 'email': email, 'office_id': officeId})
            .eq('id', userId);

        await userDao.markEmployeeAsSynced(userId);
      }

      fetchEmployees();
      return true;
    } catch (e) {
      debugPrint('Error updating employee: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        return true;
      }
      return false;
    }
  }

  Future<List<Office>> fetchOffices() async {
    try {
      final response = await supabase
          .from('offices')
          .select('*')
          .order('id', ascending: true);

      final offices = (response as List)
          .map((e) => Office.fromJson(e))
          .toList();

      await locationDao.syncOfficesToLocal(
        offices.map((e) => e.toDrift()).toList(),
      );

      return offices;
    } catch (e) {
      debugPrint('Error fetching offices online, falling back to local: $e');
      final localData = await locationDao.getAllLocations();
      return localData.map((e) => Office.fromDrift(e)).toList();
    }
  }
}
