import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presentech/features/employee/absence/model/absence.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeDetailController extends GetxController {
  final supabase = Supabase.instance.client;
  RxList<Employee> employees = <Employee>[].obs;
  late Employee employee;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) {
      Get.back();
      return;
    }
    
    employee = args as Employee;
    fetchAbsences();
  }

  RxList<Absence> absences = <Absence>[].obs;

  Future<void> fetchAbsences() async {
    try {
      final supabase = Supabase.instance.client;
      final res = await supabase
          .from('absences')
          .select()
          .eq('user_id', employee.id);

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
          .map<Employee>((item) => Employee.fromJson(item))
          .toList();

      print("Employees fetched: ${employees.length}");
    } catch (e) {
      print("Error fetch employees: $e");
      print("Employees fetched: ${employees.length}");
    } finally {}
  }

  Future<bool> updateEmployee(String name, String email) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('users')
          .update({'name': name, 'email': email})
          .eq('id', employee.id);
          fetchEmployees();
      return true;
      
    } catch (e) {
      debugPrint('Error updating employee: $e');
      return false;
    }
  }
}
