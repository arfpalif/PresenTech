import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/shared/view/components/dialog/failed_dialog.dart';
import 'package:presentech/shared/view/components/dialog/success_dialog.dart';
import 'package:presentech/shared/view/components/snackbar/failed_snackbar.dart';
import 'package:presentech/features/employee/permissions/repositories/permission_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/utils/enum/permission_filter.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';
import 'package:presentech/utils/services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeePermissionController extends GetxController {
  // Repository
  final PermissionRepository _permissionRepo;
  final SupabaseClient _supabase;

  EmployeePermissionController({
    PermissionRepository? permissionRepo,
    SupabaseClient? supabaseClient,
  }) : _permissionRepo = permissionRepo ?? PermissionRepository(),
       _supabase = supabaseClient ?? Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser?.id ?? "";

  // Controllers
  final permissionTitleController = TextEditingController();
  DateController get dateController => Get.find<DateController>();

  // Observables
  final selectedType = Rxn<PermissionType>();
  final selectedFilter = Rxn<PermissionFilter>();
  final selectedStatus = Rxn<PermissionStatus>();
  final isLoading = false.obs;
  final permissions = <Permission>[].obs;
  final _allPermissions = <Permission>[].obs;
  final connectivityService = Get.find<ConnectivityService>();

  @override
  void onInit() {
    super.onInit();
    print("EmployeePermissionController: onInit called");
    _handleArguments();
    fetchPermissions();

    ever(connectivityService.isOnline, (bool isOnline) {
      if (isOnline) {
        print("Connection restored, triggering auto-sync (Permissions)");
        fetchPermissions();
      }
    });
  }

  void _handleArguments() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args.containsKey('type')) {
        selectedType.value = args['type'];
      }
      if (args.containsKey('date')) {
        final DateTime date = args['date'];
        final dateStr = "${date.day}-${date.month}-${date.year}";
        dateController.startDateController.text = dateStr;
        dateController.endDateController.text = dateStr;
      }
    }
  }

  @visibleForTesting
  List<Permission> permissionToday({DateTime? customNow}) {
    final now = customNow ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _allPermissions.where((p) {
      final pDate = DateTime(
        p.createdAt.year,
        p.createdAt.month,
        p.createdAt.day,
      );
      return pDate.isAtSameMomentAs(today);
    }).toList();
  }

  @visibleForTesting
  List<Permission> permissionWeekly({DateTime? customNow}) {
    final now = customNow ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    return _allPermissions.where((p) {
      final pDate = DateTime(
        p.createdAt.year,
        p.createdAt.month,
        p.createdAt.day,
      );
      return !pDate.isAfter(today) && !pDate.isBefore(weekAgo);
    }).toList();
  }

  @visibleForTesting
  List<Permission> permissionMonthly({DateTime? customNow}) {
    final now = customNow ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return _allPermissions.where((p) {
      final pDate = DateTime(
        p.createdAt.year,
        p.createdAt.month,
        p.createdAt.day,
      );
      return !pDate.isAfter(today) && !pDate.isBefore(monthAgo);
    }).toList();
  }

  List<Permission> get permissionApproved {
    return _allPermissions
        .where((p) => p.status == PermissionStatus.approved)
        .toList();
  }

  List<Permission> get permissionRejected {
    return _allPermissions
        .where((p) => p.status == PermissionStatus.rejected)
        .toList();
  }

  List<Permission> get permissionPending {
    return _allPermissions
        .where((p) => p.status == PermissionStatus.pending)
        .toList();
  }

  List<Permission> get permissionCancelled {
    return _allPermissions
        .where((p) => p.status == PermissionStatus.cancelled)
        .toList();
  }

  Future<void> fetchPermissions() async {
    if (_userId.isEmpty) return;

    try {
      isLoading.value = true;
      print(
        "EmployeePermissionController: Fetching permissions for user: $_userId",
      );
      final response = await _permissionRepo.getPermissions(_userId);
      print(
        "EmployeePermissionController: Received ${response.length} permissions",
      );
      _allPermissions.assignAll(response);
      applyFilters();
    } catch (e) {
      debugPrint('Error fetching permissions: $e');
      FailedSnackbar.show("Gagal mengambil data ijin");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Permission> filteredList = _allPermissions;

    if (selectedFilter.value != null) {
      switch (selectedFilter.value!) {
        case PermissionFilter.today:
          filteredList = permissionToday();
          break;
        case PermissionFilter.week:
          filteredList = permissionWeekly();
          break;
        case PermissionFilter.month:
          filteredList = permissionMonthly();
          break;
      }
    }

    if (selectedStatus.value != null) {
      switch (selectedStatus.value!) {
        case PermissionStatus.approved:
          filteredList = filteredList
              .where((p) => p.status == PermissionStatus.approved)
              .toList();
          break;
        case PermissionStatus.rejected:
          filteredList = filteredList
              .where((p) => p.status == PermissionStatus.rejected)
              .toList();
          break;
        case PermissionStatus.pending:
          filteredList = filteredList
              .where((p) => p.status == PermissionStatus.pending)
              .toList();
          break;
        case PermissionStatus.cancelled:
          filteredList = filteredList
              .where((p) => p.status == PermissionStatus.cancelled)
              .toList();
          break;
      }
    }

    permissions.assignAll(filteredList);
  }

  Future<void> cancelPermission(
    int permissionId,
    PermissionStatus status,
  ) async {
    if (status == PermissionStatus.cancelled) {
      FailedDialog.show(
        "Failed",
        "Permintaan ijin sudah dibatalkan sebelumnya",
        () {},
      );
      return;
    }

    final id = permissionId;

    try {
      final index = _allPermissions.indexWhere((p) => p.id == id);
      if (index != -1) {
        _allPermissions[index] = Permission(
          id: _allPermissions[index].id,
          createdAt: _allPermissions[index].createdAt,
          type: _allPermissions[index].type,
          reason: _allPermissions[index].reason,
          status: PermissionStatus.cancelled,
          startDate: _allPermissions[index].startDate,
          endDate: _allPermissions[index].endDate,
          userId: _allPermissions[index].userId,
          feedback: _allPermissions[index].feedback,
        );
        applyFilters();
      }

      SuccessDialog.show("Success", "Permintaan ijin berhasil dibatalkan", () {
        Get.back();
      });

      _permissionRepo
          .updatePermission(id, {'status': PermissionStatus.cancelled.name})
          .catchError((e) {
            debugPrint('Background cancel error: $e');
            fetchPermissions();
          });
      print("berhasil membatalkan permission id: $id");
    } catch (e) {
      debugPrint('Error cancelling permission: $e');
      FailedSnackbar.show("Gagal membatalkan permintaan ijin");
    }
  }

  void changeFilter(PermissionFilter filter) {
    selectedFilter.value = (selectedFilter.value == filter) ? null : filter;
    applyFilters();
  }

  void changeStatusFilter(PermissionStatus status) {
    selectedStatus.value = (selectedStatus.value == status) ? null : status;
    applyFilters();
  }

  Future<void> submitForm() async {
    if (isLoading.value) return;

    if (permissionTitleController.text.isEmpty ||
        dateController.startDateController.text.isEmpty ||
        dateController.endDateController.text.isEmpty ||
        selectedType.value == null) {
      FailedSnackbar.show("Harap isi semua field");
      return;
    }

    DateTime? parseDate(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {
        return null;
      }
    }

    final start = parseDate(dateController.startDateController.text);
    final end = parseDate(dateController.endDateController.text);

    if (start == null || end == null) {
      FailedSnackbar.show("Format tanggal tidak valid");
      return;
    }

    final newPermission = Permission(
      createdAt: DateTime.now().toUtc(),
      startDate: start,
      endDate: end,
      type: selectedType.value!,
      reason: permissionTitleController.text,
      status: PermissionStatus.pending,
      userId: _userId,
    );

    try {
      _allPermissions.insert(0, newPermission);
      applyFilters();

      _permissionRepo
          .insertPermission(newPermission.toJson())
          .then((id) {
            if (id != null) {
              newPermission.id = id;
              print("EmployeePermissionController: Optimistic ID Updated: $id");
            }
          })
          .catchError((e) {
            debugPrint(
              'EmployeePermissionController: Background Insert Error: $e',
            );
            fetchPermissions();
          });

      SuccessDialog.show("Success", "Permintaan ijin berhasil dikirim", () {
        Get.back();
      });
    } catch (e) {
      debugPrint(
        'EmployeePermissionController: Error submitting permission: $e',
      );
      FailedSnackbar.show("Gagal mengirim permintaan ijin");
    }
  }
}
