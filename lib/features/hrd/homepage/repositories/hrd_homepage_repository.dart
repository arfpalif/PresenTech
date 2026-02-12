import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/shared/models/users.dart';
import 'package:presentech/utils/database/dao/profile_dao.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HrdHomepageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ProfileDao _profileDao = Get.find<ProfileDao>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    if (_connectivityService.isOnline.value) {
      try {
        final response = await _supabase
            .from(ApiConstant.tableUsers)
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (response != null) {
          await _syncUserToLocal(response, userId);
        }
      } catch (e) {
        print("Error fetching profile from Supabase: $e");
      }
    }

    final localProfile = await _profileDao.getProfileLocally(userId);
    if (localProfile != null) {
      return Users.fromDrift(localProfile).toJson();
    }

    throw Exception('Profile not found locally or on remote');
  }

  Future<void> _syncUserToLocal(
    Map<String, dynamic> userData,
    String userId,
  ) async {
    final existing = await _profileDao.getProfileLocally(userId);

    // Create Users model from Supabase data
    final userModel = Users.fromJson(userData);

    // Preserve local image path if it exists
    if (existing != null && existing.localImagePath != null) {
      userModel.localImagePath = existing.localImagePath;
    }

    await _profileDao.saveProfile(userModel.toDrift());
    print("Berhasil sinkronisasi profile user ke local.");
  }
}
