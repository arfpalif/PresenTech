class Absence {
  int id;
  String createdAt;
  DateTime date;
  String? clockIn;
  String? clockOut;
  dynamic status;
  String userId;
  String? userName;

  Absence({
    required this.id,
    required this.createdAt,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
    required this.userId,
    this.userName,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    id: json["id"],
    createdAt: json["created_at"],
    date: DateTime.parse(json["date"]),
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    status: json["status"],
    userId: json["user_id"],
    userName: (json["users"] is Map<String, dynamic>)
        ? json["users"]["name"]
        : json["name"],
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
