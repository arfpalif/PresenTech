import 'package:get/get.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdLocationRepository {
  //repository
  final supabase = Supabase.instance.client;

  //models
  final RxList<Office> offices = <Office>[].obs;

  //Variables
  final isLoading = false.obs;

  Future<void> fetchOffices() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('offices')
          .select()
          .order('id', ascending: true);

      final data = (response as List).map((e) {
        return Office.fromJson(e);
      }).toList();

      offices.assignAll(data);
    } catch (e) {
      throw ('Error fetching offices: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
