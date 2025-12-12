import 'dart:convert';

List<Absence> absenceFromJson(String str) =>
    List<Absence>.from(json.decode(str).map((x) => Absence.fromJson(x)));

String absenceToJson(List<Absence> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Absence {
  int id;
  String createdAt;
  DateTime date;
  String clockIn;
  String clockOut;
  dynamic status;
  String userId;

  Absence({
    required this.id,
    required this.createdAt,
    required this.date,
    required this.clockIn,
    required this.clockOut,
    required this.status,
    required this.userId,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    id: json["id"],
    createdAt: json["created_at"],
    date: DateTime.parse(json["date"]),
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    status: json["status"],
    userId: json["user_id"],
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
