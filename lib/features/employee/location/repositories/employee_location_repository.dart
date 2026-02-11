import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/features/hrd/location/model/office.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeLocationRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

  final RxList<Office> offices = <Office>[].obs;
  final isLoading = false.obs;

  Future<Office?> fetchUserOffice(String userId) async {
    if (connectivityService.isOnline.value) {
      try {
        final response = await supabase
            .from(ApiConstant.tableUsers)
            .select('name, office_id(*)')
            .eq('id', userId)
            .maybeSingle();

        debugPrint(
          "EmployeeLocationRepository: Remote user profile response: $response",
        );

        if (response != null && response['office_id'] != null) {
          final officeData = response['office_id'];

          await databaseService.saveOfficeLocally(
            Map<String, dynamic>.from(officeData as Map),
          );

          final office = Office.fromJson(Map<String, dynamic>.from(officeData));
          debugPrint(
            "EmployeeLocationRepository: Parsed office: ${office.name}",
          );
          return office;
        } else {
          debugPrint(
            "EmployeeLocationRepository: No office assigned to user in Supabase.",
          );
        }
      } catch (e) {
        debugPrint(
          "EmployeeLocationRepository: Error fetching office from remote: $e",
        );
      }
    }

    try {
      final localUser = await databaseService.getProfileLocally(userId);
      debugPrint("EmployeeLocationRepository: Local user profile: $localUser");

      if (localUser != null && localUser['office_id'] != null) {
        final officeIdRaw = localUser['office_id'];
        final int? officeId = officeIdRaw is int
            ? officeIdRaw
            : int.tryParse(officeIdRaw.toString());

        debugPrint(
          "EmployeeLocationRepository: Local officeId parsed: $officeId",
        );

        if (officeId != null) {
          final localOffice = await databaseService.getOfficeLocallyById(
            officeId,
          );
          if (localOffice != null) {
            debugPrint(
              "EmployeeLocationRepository: Office loaded from local database: ${localOffice['name']}",
            );
            return Office.fromJson(localOffice);
          } else {
            debugPrint(
              "EmployeeLocationRepository: Office with id $officeId not found in local DB.",
            );
          }
        } else {
          debugPrint("EmployeeLocationRepository: Parsed officeId is null.");
        }
      } else {
        debugPrint(
          "EmployeeLocationRepository: No office_id found in local user profile.",
        );
      }
    } catch (e) {
      debugPrint(
        "EmployeeLocationRepository: Error fetching office from local: $e",
      );
    }

    return null;
  }
}
