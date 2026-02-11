import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:presentech/features/hrd/employee/repositories/hrd_employee_repository.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdEmployeeDetailController extends GetxController {
  //repository
  final employeeRepo = HrdEmployeeRepository();
  final supabase = Supabase.instance.client;
  RxList<Employee> employees = <Employee>[].obs;
  late Employee employee;
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

    employee = args as Employee;
    fetchOffices();
    fetchAbsences();
  }

  RxList<Absence> absences = <Absence>[].obs;

  Future<void> fetchAbsences() async {
    try {
      final res = await employeeRepo.fetchUserAbsences();

      absences.value = (res as List).map((e) => Absence.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load absences: $e');
    }
  }

  Future<void> fetchEmployees() async {
    try {
      final res = await employeeRepo.fetchEmployees();
      employees.assignAll(res);
      
      print("Employees fetched: ${employees.length}");
    } catch (e) {
      print("Error fetch employees: $e");
    }
  }

  Future<bool> updateEmployee(String name, String email, int officeId) async {
    try {
      final success = await employeeRepo.updateEmployee(name, email, officeId, employee.id);
      if (success) {
        await fetchEmployees();
      }
      return success;
    } catch (e) {
      debugPrint('Error updating employee: $e');
      return false;
    }
  }

  Future<void> fetchOffices() async {
    try {
      isLoadingOffices.value = true;
      final response = await employeeRepo.fetchOffices();

      final data = (response as List)
          .map<Office>((item) => Office.fromJson(item))
          .toList();
      offices.assignAll(data);

      Office? found;
      for (final office in offices) {
        if (office.id == employee.officeId) {
          found = office;
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
