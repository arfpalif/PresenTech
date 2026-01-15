import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/repositories/hrd_employee_repository.dart';
import 'package:presentech/shared/models/users.dart';



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

  var filteredEmployees = <Users>[].obs;
  var searchQuery = ''.obs;

  RxList<Users> employees = <Users>[].obs;
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
          .map<Users>((item) => Users.fromJson(item))
          .toList();
      filteredEmployees.assignAll(employees);
    } catch (e) {
      throw ('Failed to fetch employees: $e');
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
