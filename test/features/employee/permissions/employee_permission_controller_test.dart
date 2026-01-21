import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:presentech/features/employee/permissions/controller/employee_permission_controller.dart';
import 'package:presentech/features/employee/permissions/repositories/permission_repository.dart';
import 'package:presentech/shared/controllers/date_controller.dart';
import 'package:presentech/shared/models/permission.dart';
import 'package:presentech/utils/enum/permission_filter.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockPermissionRepository extends Mock implements PermissionRepository {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}

void main() {
  late EmployeePermissionController controller;
  late MockPermissionRepository mockRepo;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late DateController dateController;

  setUp(() {
    Get.testMode = true;
    mockRepo = MockPermissionRepository();
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    
    // Setup DateController (needed by EmployeePermissionController)
    dateController = DateController();
    Get.put(dateController);

    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('user-123');

    // Default mock behavior
    when(() => mockRepo.getPermissions(any())).thenAnswer((_) async => []);

    controller = EmployeePermissionController(
      permissionRepo: mockRepo,
      supabaseClient: mockSupabase,
    );
  });

  tearDown(() {
    Get.delete<DateController>();
  });

  group('EmployeePermissionController Filter Logic', () {
    test('permissionToday should filter correctly', () {
      final now = DateTime(2024, 1, 20);
      final p1 = Permission(
        createdAt: DateTime(2024, 1, 20, 10), // Today
        startDate: DateTime(2024, 1, 20),
        endDate: DateTime(2024, 1, 20),
        type: PermissionType.sick,
        reason: 'Sakit',
        status: PermissionStatus.pending,
      );
      final p2 = Permission(
        createdAt: DateTime(2024, 1, 19), // Yesterday
        startDate: DateTime(2024, 1, 19),
        endDate: DateTime(2024, 1, 19),
        type: PermissionType.sick,
        reason: 'Sakit',
        status: PermissionStatus.pending,
      );

      // We need to set _allPermissions. Since it's private, we'll use fetchPermissions mock
      when(() => mockRepo.getPermissions(any())).thenAnswer((_) async => [p1, p2]);

      // Trigger fetch
      return controller.fetchPermissions().then((_) {
        final filtered = controller.permissionToday(customNow: now);
        expect(filtered.length, 1);
        expect(filtered.first.createdAt.day, 20);
      });
    });

    test('permissionWeekly should filter last 7 days', () {
      final now = DateTime(2024, 1, 20);
      final p1 = Permission(
        createdAt: DateTime(2024, 1, 15), // Within week
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 15),
        type: PermissionType.sick,
        reason: 'Sakit',
        status: PermissionStatus.pending,
      );
      final p2 = Permission(
        createdAt: DateTime(2024, 1, 10), // Outside week
        startDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 10),
        type: PermissionType.sick,
        reason: 'Sakit',
        status: PermissionStatus.pending,
      );

      when(() => mockRepo.getPermissions(any())).thenAnswer((_) async => [p1, p2]);

      return controller.fetchPermissions().then((_) {
        final filtered = controller.permissionWeekly(customNow: now);
        expect(filtered.length, 1);
        expect(filtered.first.createdAt.day, 15);
      });
    });
  });

  group('EmployeePermissionController Submission Logic', () {
    test('should NOT submit if fields are empty', () async {
      controller.permissionTitleController.text = '';
      
      await controller.submitForm();
      
      verifyNever(() => mockRepo.insertPermission(any()));
    });

    test('should submit correctly if fields are valid', () async {
      controller.permissionTitleController.text = 'Sakit demam';
      controller.selectedType.value = PermissionType.sick;
      dateController.startDateController.text = '20-01-2024';
      dateController.endDateController.text = '21-01-2024';

      when(() => mockRepo.insertPermission(any())).thenAnswer((_) async => {});
      when(() => mockRepo.getPermissions(any())).thenAnswer((_) async => []);

      await controller.submitForm();

      verify(() => mockRepo.insertPermission(any())).called(1);
    });
  });

  group('EmployeePermissionController Cancellation Logic', () {
    test('should NOT cancel if already cancelled', () async {
      await controller.cancelPermission('1', PermissionStatus.cancelled);
      
      verifyNever(() => mockRepo.updatePermission(any(), any()));
    });

    test('should cancel correctly if pending', () async {
      when(() => mockRepo.updatePermission(any(), any())).thenAnswer((_) async => {});
      
      await controller.cancelPermission('1', PermissionStatus.pending);

      verify(() => mockRepo.updatePermission(1, {'status': 'cancelled'})).called(1);
    });
  });
}
