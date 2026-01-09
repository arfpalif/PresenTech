import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/repositories/hrd_employee_repository.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeDetailController extends GetxController {
  //repository
  final employeeRepo = HrdEmployeeRepository();
  final supabase = Supabase.instance.client;
  RxList<Users> employees = <Users>[].obs;
  late Users employee;
  final RxBool isLoadingOffices = false.obs;
  final RxList<Office> offices = <Office>[].obs;
  final Rxn<Office> selectedOffice = Rxn<Office>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) {
      Get.back();
      return;
    }

    employee = args as Users;
    fetchOffices();
    fetchAbsences();
  }

  RxList<Absence> absences = <Absence>[].obs;

  Future<void> fetchAbsences() async {
    try {
      final supabase = Supabase.instance.client;
      final res = await supabase
          .from('absences')
          .select()
          .eq('user_id', employee.id)
          .order('created_at', ascending: false);

      absences.value = (res as List).map((e) => Absence.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load absences: $e');
    }
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .order('id', ascending: true);
      employees.value = response
          .map<Users>((item) => Users.fromJson(item))
          .toList();

      print("Employees fetched: ${employees.length}");
    } catch (e) {
      print("Error fetch employees: $e");
      print("Employees fetched: ${employees.length}");
    } finally {}
  }

  Future<bool> updateEmployee(String name, String email, int officeId) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('users')
          .update({'name': name, 'email': email, 'office_id': officeId})
          .eq('id', employee.id);
      fetchEmployees();
      return true;
    } catch (e) {
      debugPrint('Error updating employee: $e');
      return false;
    }
  }

  Future<void> fetchOffices() async {
    try {
      isLoadingOffices.value = true;
      final response = await supabase
          .from('offices')
          .select('*')
          .order('id', ascending: true);

      final data = (response as List)
          .map<Office>((item) => Office.fromJson(item))
          .toList();
      offices.assignAll(data);

      Office? found;
      for (final offices in offices) {
        if (offices.id == employee.officeId) {
          found = offices;
          break;
        }
      }
      selectedOffice.value = found;
    } catch (e) {
      debugPrint('Error fetching offices: $e');
    } finally {
      isLoadingOffices.value = false;
    }
  }
}
