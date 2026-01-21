import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presentech/features/employee/absence/controllers/presence_controller.dart';
import 'package:presentech/features/employee/absence/repositories/absence_repository.dart';
import 'package:presentech/utils/enum/absence_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockUser extends Mock implements User {}

void main() {
  late PresenceController controller;
  late MockAbsenceRepository mockRepo;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUp(() {
    Get.testMode = true;
    mockRepo = MockAbsenceRepository();
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockSupabase.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('user-123');

    // Default mock behavior to prevent crashes
    when(() => mockRepo.getTodayAbsence(userId: any(named: 'userId'), today: any(named: 'today')))
        .thenAnswer((_) async => null);
    
    when(() => mockRepo.getUserOffice(userId: any(named: 'userId')))
        .thenAnswer((_) async => null);

    controller = PresenceController(absenceRepo: mockRepo, supabaseClient: mockSupabase);
  });

  group('PresenceController Status Determination', () {
    test('should return HADIR when clocking in exactly at start time', () {
      final now = DateTime(2024, 1, 1, 8, 0, 0);
      final startTime = '08:00:00';
      final result = controller.compareWithWorkStartForTest(startTime, customNow: now);
      expect(result, AbsenceStatus.hadir.name);
    });

    test('should return TERLAMBAT when clocking in within 1 hour after start time', () {
      final now = DateTime(2024, 1, 1, 8, 30, 0);
      final startTime = '08:00:00';
      final result = controller.compareWithWorkStartForTest(startTime, customNow: now);
      expect(result, AbsenceStatus.terlambat.name);
    });
  });

  group('PresenceController Distance Calculation', () {
    test('should calculate distance correctly between two points', () {
      final lat1 = -6.1754; // Jakarta
      final lon1 = 106.8272;
      final lat2 = -6.1755; // Nearby
      final lon2 = 106.8273;

      final distance = controller.calculateDistance(lat1, lon1, lat2, lon2);
      
      // Distance should be around 15-20 meters
      expect(distance, greaterThan(10));
      expect(distance, lessThan(30));
    });
  });

  group('PresenceController Submission Logic (Location)', () {
    test('should NOT proceed if user is outside office radius', () async {
      final myPosition = Position(
        latitude: -6.1754,
        longitude: 106.8272,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      final officeData = {
        'latitude': -7.0, // Far away
        'longitude': 110.0,
        'radius': 100,
      };

      // Since we can't easily mock the snackbar in unit tests without a lot of setup,
      // we just verify that it doesn't call handleClockIn/Out.
      // However, we can't easily verify private method calls.
      // We'll verify that repo methods are NOT called.
      
      await controller.submitAbsence(customPosition: myPosition, customOffice: officeData);

      verifyNever(() => mockRepo.clockIn(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        date: any(named: 'date'),
        clockIn: any(named: 'clockIn'),
      ));
    });

    test('should proceed to clock in if inside radius and no today absence', () async {
      final myPosition = Position(
        latitude: -6.1754,
        longitude: 106.8272,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      final officeData = {
        'latitude': -6.1754,
        'longitude': 106.8272,
        'radius': 100,
        'office_id': 1
      };

      when(() => mockRepo.getTodayAbsence(userId: any(named: 'userId'), today: any(named: 'today')))
          .thenAnswer((_) async => null);
      
      when(() => mockRepo.getUserOffice(userId: any(named: 'userId')))
          .thenAnswer((_) async => {'office_id': 1});
      
      when(() => mockRepo.getOfficeHours(officeId: 1))
          .thenAnswer((_) async => {'start_time': '08:00:00'});

      when(() => mockRepo.clockIn(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        date: any(named: 'date'),
        clockIn: any(named: 'clockIn'),
      )).thenAnswer((_) async => {});

      await controller.submitAbsence(customPosition: myPosition, customOffice: officeData);

      verify(() => mockRepo.clockIn(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        date: any(named: 'date'),
        clockIn: any(named: 'clockIn'),
      )).called(1);
    });

    test('should proceed to clock out if inside radius and already clocked in', () async {
      final myPosition = Position(
        latitude: -6.1754,
        longitude: 106.8272,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      final officeData = {
        'latitude': -6.1754,
        'longitude': 106.8272,
        'radius': 100,
        'office_id': 1
      };

      // Mock that user has already clocked in
      when(() => mockRepo.getTodayAbsence(userId: any(named: 'userId'), today: any(named: 'today')))
          .thenAnswer((_) async => {
                'clock_in': '08:00:00',
                'clock_out': null,
                'status': 'hadir'
              });

      when(() => mockRepo.clockOut(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        clockOut: any(named: 'clockOut'),
      )).thenAnswer((_) async => {});

      await controller.submitAbsence(customPosition: myPosition, customOffice: officeData);

      verify(() => mockRepo.clockOut(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        clockOut: any(named: 'clockOut'),
      )).called(1);
    });
  });
}
