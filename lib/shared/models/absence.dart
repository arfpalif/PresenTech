import 'package:drift/drift.dart' hide Column;
import 'package:presentech/utils/database/database.dart';
import 'package:presentech/utils/enum/absence_status.dart';

class Absence {
  int id;
  String? createdAt;
  DateTime date;
  String? clockIn;
  String? clockOut;
  AbsenceStatus? status;
  String userId;
  String? userName;
  int? isSynced;
  String? syncAction;

  Absence({
    required this.id,
    required this.createdAt,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.status,
    required this.userId,
    this.userName,
    this.isSynced,
    this.syncAction,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    id: json["id"] ?? 0,
    createdAt: json["created_at"],
    date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    userId: json["user_id"] ?? "",
    userName: (json["users"] is Map<String, dynamic>)
        ? json["users"]["name"]
        : json["name"],
    status: json["status"] == "alfa"
        ? AbsenceStatus.alfa
        : json["status"] == "hadir"
        ? AbsenceStatus.hadir
        : json["status"] == "terlambat"
        ? AbsenceStatus.terlambat
        : json["status"] == "izin"
        ? AbsenceStatus.izin
        : null,
    isSynced: json["is_synced"],
    syncAction: json["sync_action"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "clock_in": clockIn,
    "clock_out": clockOut,
    "status": status?.name,
    "user_id": userId,
    "is_synced": isSynced,
    "sync_action": syncAction,
  };

  factory Absence.fromDrift(AbsencesTableData data) => Absence(
    id: data.id,
    createdAt: data.createdAt?.toIso8601String(),
    date: data.date,
    userName: data.userName,
    clockIn: data.clockIn,
    clockOut: data.clockOut,
    status: data.status == "alfa"
        ? AbsenceStatus.alfa
        : data.status == "hadir"
        ? AbsenceStatus.hadir
        : data.status == "terlambat"
        ? AbsenceStatus.terlambat
        : data.status == "izin"
        ? AbsenceStatus.izin
        : null,
    userId: data.userId,
    isSynced: data.isSynced,
    syncAction: data.syncAction,
  );

  AbsencesTableCompanion toDrift() => AbsencesTableCompanion(
    id: id != 0 ? Value(id) : const Value.absent(),
    createdAt: Value(createdAt != null ? DateTime.parse(createdAt!) : null),
    date: Value(date),
    clockIn: Value(clockIn),
    clockOut: Value(clockOut),
    userName: Value(userName),
    status: Value(status?.name),
    userId: Value(userId),
    isSynced: Value(isSynced ?? 0),
    syncAction: Value(syncAction),
  );
}
