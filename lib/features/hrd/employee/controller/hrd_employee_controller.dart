import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:presentech/features/hrd/employee/repositories/hrd_employee_repository.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/utils/database/dao/hrd/user_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';

class HrdEmployeeController extends GetxController {
  //repository
  final employeeRepo = HrdEmployeeRepository();

  //variables
  var statusAbsen = "".obs;
  var profileUrl = "".obs;
  var name = "".obs;

  //text editing controller

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();

  //connectivityService
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();

  //Dao
  final UserDao userDao = Get.find<UserDao>();

  var filteredEmployees = <Employee>[].obs;
  var searchQuery = ''.obs;

  RxList<Employee> employees = <Employee>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    ever(employees, (List<Employee> data) {
      if (searchQuery.isEmpty) {
        filteredEmployees.assignAll(data);
      } else {
        searchEmployee(searchQuery.value);
      }
    });

    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await employeeRepo.fetchEmployees();
      employees.assignAll(response);
    } catch (e) {
      debugPrint('Error fetching employees: $e');
      FailedSnackbar.show('Failed to fetch employees');
    }
    
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
