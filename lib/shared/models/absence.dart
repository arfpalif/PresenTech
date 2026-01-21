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

  Absence({
    required this.id,
    required this.createdAt,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.status,
    required this.userId,
    this.userName,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    id: json["id"],
    createdAt: json["created_at"],
    date: DateTime.parse(json["date"]),
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    userId: json["user_id"],
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "clock_in": clockIn,
    "clock_out": clockOut,
    "status": status,
    "user_id": userId,
  };
}
