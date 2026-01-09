import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdLocationRepository {
  //repository
  final supabase = Supabase.instance.client;

  //models
  final RxList<Office> offices = <Office>[].obs;

  //Variables
  final isLoading = false.obs;

  Future<List<Map<String, dynamic>>> fetchOffices() async {
    try {
      final response = await supabase
          .from(ApiConstant.tableOffices)
          .select('*')
          .order('id', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ('Error fetching offices: $e');
    }
  }

  Future<void> addOfficeLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      isLoading.value = true;

      await supabase.from(ApiConstant.tableOffices).insert({
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      });
    } catch (e) {
      throw ('Error adding office location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOfficeLocation(
    Office office, {
    String? officeId,
    double? latitude,
    double? longitude,
    double? radius,
    String? name,
    String? address,
  }) async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from(ApiConstant.tableOffices)
          .update({
            'latitude': latitude,
            'longitude': longitude,
            'radius': radius,
            'name': name,
            'address': address,
          })
          .eq('id', officeId!);
      print(response);
    } catch (e) {
      throw ('Error updating office location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOfficeLocation(String officeId) async {
    try {
      isLoading.value = true;

      await supabase.from(ApiConstant.tableOffices).delete().eq('id', officeId);
    } catch (e) {
      throw ('Error deleting office location: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
