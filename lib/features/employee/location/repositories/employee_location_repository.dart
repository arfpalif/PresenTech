import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeLocationRepository {
  //repository
  final supabase = Supabase.instance.client;

  //models
  final RxList<Office> offices = <Office>[].obs;

  //Variables
  final isLoading = false.obs;

  Future<Office?> fetchUserOffice(String userId) async {
    try {
      final response = await supabase
          .from(ApiConstant.tableUsers)
          .select('name, office_id(*)')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      final officeData = response['office_id'];
      if (officeData == null) return null;

      return Office.fromJson(Map<String, dynamic>.from(officeData as Map));
    } catch (e) {
      FailedSnackbar.show("Tidak dapat memuat data lokasi: ${e.toString()}");
      throw ('Error fetching offices: $e');
    }
  }
}
