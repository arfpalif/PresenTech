import 'dart:io';

import 'package:get/get.dart' hide Value;
import 'package:presentech/constants/api_constant.dart';
import 'package:presentech/utils/database/dao/profile_dao.dart';
import 'package:presentech/utils/database/database.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

class ProfileRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  final ProfileDao profileDao = Get.find<ProfileDao>();

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    if (connectivityService.isOnline.value) {
      await syncOfflineProfiles();
      try {
        final response = await supabase
            .from(ApiConstant.tableUsers)
            .select()
            .eq('id', userId)
            .single();

        await _syncUserToLocal(response, userId);
      } catch (e) {
        print("Error fetching profile from Supabase: $e");
      }
    }
    await syncOfflineProfiles();
    final localProfile = await profileDao.getProfileLocally(userId);
    if (localProfile != null) {
      return _driftToMap(localProfile);
    }

    throw Exception('Profile not found locally or on remote');
  }

  Future<void> _syncUserToLocal(
    Map<String, dynamic> userData,
    String userId,
  ) async {
    final existing = await profileDao.getProfileLocally(userId);
    String? localImagePath;
    if (existing != null && existing.localImagePath != null) {
      localImagePath = existing.localImagePath;
    }

    await profileDao.saveProfile(
      UsersTableCompanion(
        id: Value(userId),
        name: Value(userData['name']),
        email: Value(userData['email']),
        role: Value(userData['role']),
        profilePicture: Value(userData['profile_picture']),
        officeId: Value(
          userData['office_id'] is int
              ? userData['office_id']
              : int.tryParse(userData['office_id']?.toString() ?? ''),
        ),
        createdAt: Value(
          userData['created_at'] != null
              ? DateTime.tryParse(userData['created_at'])
              : null,
        ),
        isSynced: const Value(1),
        syncAction: const Value(null),
        localImagePath: Value(localImagePath),
      ),
    );
    print(
      "Berhasil sinkronisasi profile user ke local (local_image_path preserved).",
    );
  }

  Map<String, dynamic> _driftToMap(UsersTableData data) {
    return {
      'id': data.id,
      'name': data.name,
      'email': data.email,
      'role': data.role,
      'profile_picture': data.profilePicture,
      'office_id': data.officeId,
      'created_at': data.createdAt?.toIso8601String(),
      'is_synced': data.isSynced,
      'sync_action': data.syncAction,
      'local_image_path': data.localImagePath,
    };
  }

  Future<void> updateProfile({
    required String name,
    String? localImagePath,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final existingProfile = await profileDao.getProfileLocally(userId);

    await profileDao.saveProfile(
      UsersTableCompanion(
        id: Value(userId),
        name: Value(name),
        email: Value(existingProfile?.email),
        role: Value(existingProfile?.role),
        officeId: Value(existingProfile?.officeId),
        profilePicture: Value(existingProfile?.profilePicture),
        createdAt: Value(existingProfile?.createdAt),
        localImagePath: Value(
          localImagePath ?? existingProfile?.localImagePath,
        ),
        isSynced: const Value(0),
        syncAction: const Value('update'),
      ),
    );

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

      await profileDao.markProfileAsSynced(userId);

      if (imageUrl != null) {
        await profileDao.saveProfile(
          UsersTableCompanion(
            id: Value(userId),
            profilePicture: Value(imageUrl),
          ),
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
      final unsyncedProfiles = await profileDao.getUnsyncedProfiles();
      if (unsyncedProfiles.isEmpty) return;

      for (var profile in unsyncedProfiles) {
        final userId = profile.id;
        final name = profile.name ?? '';
        final localImagePath = profile.localImagePath;

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
