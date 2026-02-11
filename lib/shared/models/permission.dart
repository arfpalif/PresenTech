import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';

import 'package:drift/drift.dart' hide Column;
import 'package:presentech/utils/database/database.dart';

extension PermissionTypeX on PermissionType {
  String get value => switch (this) {
    PermissionType.permission => 'permission',
    PermissionType.leave => 'leave',
    PermissionType.absence_error => 'absence_error',
    PermissionType.sick => 'sick',
  };

  static PermissionType fromString(String? s) {
    switch (s) {
      case 'leave':
        return PermissionType.leave;
      case 'absence_error':
        return PermissionType.absence_error;
      case 'sick':
        return PermissionType.sick;
      case 'permission':
      default:
        return PermissionType.permission;
    }
  }
}

extension PermissionStatusX on PermissionStatus {
  static PermissionStatus fromString(String? s) {
    return PermissionStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PermissionStatus.pending,
    );
  }
}

List<Permission> permissionFromJson(String str) =>
    List<Permission>.from(json.decode(str).map((x) => Permission.fromJson(x)));

String permissionToJson(List<Permission> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Permission {
  int? id;
  DateTime createdAt;
  PermissionType type;
  String reason;
  PermissionStatus status;
  DateTime startDate;
  DateTime endDate;
  String? userId;
  String? feedback;
  int? isSynced;
  String? syncAction;

  Permission({
    this.id,
    required this.createdAt,
    required this.type,
    required this.reason,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.userId,
    this.feedback,
    this.isSynced,
    this.syncAction,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is String) return DateTime.parse(v);
      return DateTime.now();
    }

    DateTime toYmd(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    final created = parseDate(json["created_at"]);
    final start = parseDate(json["start_date"]);
    final end = parseDate(json["end_date"]);

    return Permission(
      id: json["id"],
      createdAt: created,
      type: PermissionTypeX.fromString(json["type"]),
      reason: json["reason"],
      status: PermissionStatusX.fromString(json["status"]),
      startDate: toYmd(start),
      endDate: toYmd(end),
      userId: json["user_id"],
      feedback: json["feedback"],
      isSynced: json["is_synced"] ?? 1,
      syncAction: json["sync_action"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "type": type.value,
    "reason": reason,
    "status": (status).name,
    "start_date": DateFormat('yyyy-MM-dd').format(startDate),
    "end_date": DateFormat('yyyy-MM-dd').format(endDate),
    "user_id": userId,
    "feedback": feedback,
    "is_synced": isSynced,
    "sync_action": syncAction,
  };

  factory Permission.fromDrift(PermissionsTableData data) => Permission(
    id: data.id,
    createdAt: data.createdAt,
    type: PermissionTypeX.fromString(data.type),
    reason: data.reason,
    status: PermissionStatusX.fromString(data.status),
    startDate: data.startDate,
    endDate: data.endDate,
    userId: data.userId,
    feedback: data.feedback,
    isSynced: data.isSynced,
    syncAction: data.syncAction,
  );

  PermissionsTableCompanion toDrift() => PermissionsTableCompanion(
    id: id != null ? Value(id!) : const Value.absent(),
    userId: Value(userId ?? ""),
    type: Value(type.value),
    reason: Value(reason),
    status: Value((status).name),
    startDate: Value(startDate),
    endDate: Value(endDate),
    feedback: Value(feedback),
    createdAt: Value(createdAt),
    isSynced: Value(isSynced ?? 0),
    syncAction: Value(syncAction),
  );

  String get createdAtYmd => DateFormat('dd-MMM-yyyy').format(createdAt);
  String get startDateYmd => DateFormat('yyyy-MM-dd').format(startDate);
  String get endDateYmd => DateFormat('yyyy-MM-dd').format(endDate);
}
