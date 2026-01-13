import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:presentech/utils/enum/permission_status.dart';
import 'package:presentech/utils/enum/permission_type.dart';

extension PermissionTypeX on PermissionType {
  String get value => switch (this) {
    PermissionType.permission => 'permission',
    PermissionType.leave => 'leave',
  };

  static PermissionType fromString(String? s) {
    switch (s) {
      case 'leave':
        return PermissionType.leave;
      case 'permission':
      default:
        return PermissionType.permission;
    }
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
  dynamic status;
  DateTime startDate;
  DateTime endDate;
  String? userId;
  String? feedback;

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
      status: PermissionStatus.values.firstWhere(
        (e) => e.toString() == 'PermissionStatus.${json["status"]}',
        orElse: () => PermissionStatus.pending,
      ),
      startDate: toYmd(start),
      endDate: toYmd(end),
      userId: json["user_id"],
      feedback: json["feedback"],
    );
  }

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "type": type.value,
    "reason": reason,
    "start_date": DateFormat('yyyy-MM-dd').format(startDate),
    "end_date": DateFormat('yyyy-MM-dd').format(endDate),
    "user_id": userId,
    "feedback": feedback,
  };

  String get createdAtYmd => DateFormat('dd-MMM-yyyy').format(createdAt);
  String get startDateYmd => DateFormat('yyyy-MM-dd').format(startDate);
  String get endDateYmd => DateFormat('yyyy-MM-dd').format(endDate);
}
