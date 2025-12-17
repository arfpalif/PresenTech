import 'package:get/get.dart';
import 'package:presentech/features/hrd/employee/models/employee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AbsenceFilter { today, week, month }

class HrdEmployeeController extends GetxController {
  final supabase = Supabase.instance.client;
  var statusAbsen = "".obs;
  var selectedFilter = Rxn<AbsenceFilter>();

  RxList<Employee> employees = <Employee>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<Map<String, dynamic>> getOffice() async {
    final user = await supabase.from("users").select("office_id").maybeSingle();

    final officeId = user?['office_id'];

    if (user == null || officeId == null) {
      Get.snackbar("Error", "User tidak termasuk dalam office apapun");
      throw Exception("User dont have office");
    }

    final office = await supabase
        .from("offices")
        .select()
        .eq("id", officeId)
        .maybeSingle();
    print("office row => $office");

    if (office == null) {
      Get.snackbar("Error", "Tidak ada office");
      throw Exception("Error");
    }
    return office;
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
}
