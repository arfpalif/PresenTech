import 'dart:io';

import 'package:get/get.dart';
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:presentech/utils/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    // 1. If online, try to sync offline data first, then fetch latest from remote
    if (connectivityService.isOnline.value) {
      await syncOfflineProfiles();
      try {
        final response = await supabase
            .from(ApiConstant.tableUsers)
            .select()
            .eq('id', userId)
            .single();

        // Sync remote data to local
        await databaseService.syncUserToLocal(response, userId);
      } catch (e) {
        print("Error fetching profile from Supabase: $e");
      }
    }

    // 2. Always return data from local database
    final localProfile = await databaseService.getProfileLocally(userId);
    if (localProfile != null) {
      return localProfile;
    }

    throw Exception('Profile not found locally or on remote');
  }

  Future<void> updateProfile({
    required String name,
    String? localImagePath,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final existingProfile = await databaseService.getProfileLocally(userId);

    final profileData = {
      'id': userId,
      'name': name,
      'email': existingProfile?['email'] ?? '',
      'role': existingProfile?['role'] ?? '',
      'office_id': existingProfile?['office_id'],
      'profile_picture': existingProfile?['profile_picture'],
      'created_at': existingProfile?['created_at'],
      'local_image_path':
          localImagePath ?? existingProfile?['local_image_path'],
      'is_synced': 0,
      'sync_action': 'update',
    };

    await databaseService.saveProfileLocally(profileData);
    print("Profile saved locally (Offline mode)");

    // 3. Trigger sync if online
    if (connectivityService.isOnline.value) {
      _syncToSupabase(userId, name, localImagePath);
    }
  }

  Future<void> _syncToSupabase(
    String userId,
    String name,
    String? localImagePath,
  ) async {
    try {
      String? imageUrl;

      if (localImagePath != null) {
        final file = File(localImagePath);
        if (await file.exists()) {
          imageUrl = await _uploadImageToSupabase(userId, file);
        }
      }

      final Map<String, dynamic> updates = {'name': name};
      if (imageUrl != null) {
        updates['profile_picture'] = imageUrl;
      }
      await supabase
          .from(ApiConstant.tableUsers)
          .update(updates)
          .eq('id', userId);

      await databaseService.markProfileAsSynced(userId);

      if (imageUrl != null) {
        final db = await databaseService.database;
        await db.update(
          ApiConstant.tableUsers,
          {'profile_picture': imageUrl},
          where: 'id = ?',
          whereArgs: [userId],
        );
      }

      print("Profile synced to Supabase successfully");
    } catch (e) {
      print("Failed to sync profile to Supabase (Background): $e");
    }
  }

  Future<String?> _uploadImageToSupabase(String userId, File file) async {
    try {
      final filePath = 'profile-$userId.jpg';
      await supabase.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );
      final url = supabase.storage.from('avatars').getPublicUrl(filePath);
      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> syncOfflineProfiles() async {
    try {
      final unsyncedProfiles = await databaseService.getUnsyncedProfiles();
      if (unsyncedProfiles.isEmpty) return;

      for (var profile in unsyncedProfiles) {
        final userId = profile['id'] as String;
        final name = profile['name'] as String? ?? '';
        final localImagePath = profile['local_image_path'] as String?;

        await _syncToSupabase(userId, name, localImagePath);
      }
    } catch (e) {
      print('Error syncing offline profiles: $e');
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase
        .from('users')
        .update({'profile_picture': imageUrl})
        .eq('id', userId);
  }
}
