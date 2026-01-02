import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:presentech/features/hrd/employee/repositories/hrd_employee_repository.dart';

enum AbsenceFilter { today, week, month }

class HrdEmployeeController extends GetxController {
  //repository
  final employeeRepo = HrdEmployeeRepository();

  //variables
  var statusAbsen = "".obs;
  var profileUrl = "".obs;
  var name = "".obs;

  var filteredEmployees = <Employee>[].obs;
  var searchQuery = ''.obs;

  RxList<Employee> employees = <Employee>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await employeeRepo.fetchEmployees();
      employees.value = response
          .map<Employee>((item) => Employee.fromJson(item))
          .toList();
      print("Employees fetched: ${employees.length}");
      filteredEmployees.assignAll(employees);
    } catch (e) {
      print("Error fetch employees: $e");
      print("Employees fetched: ${employees.length}");
    } finally {}
  }

  void searchEmployee(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      filteredEmployees.assignAll(
        employees
            .where(
              (e) =>
                  e.name.toLowerCase().contains(query.toLowerCase()) ||
                  e.role.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}
