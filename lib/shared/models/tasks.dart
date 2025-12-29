// To parse this JSON data, do
//
//     final tasks = tasksFromJson(jsonString);

import 'dart:convert';

List<Tasks> tasksFromJson(String str) =>
    List<Tasks>.from(json.decode(str).map((x) => Tasks.fromMap(x)));

String tasksToJson(List<Tasks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Tasks {
  String createdAt;
  String acceptanceCriteria;
  DateTime startDate;
  DateTime endDate;
  String priority;
  String level;
  int? id;
  String title;
  String userId;
  String? userName;

  Tasks({
    required this.createdAt,
    required this.acceptanceCriteria,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.level,
    this.id,
    required this.title,
    required this.userId,
    this.userName,
  });

  factory Tasks.fromMap(Map<String, dynamic> json) => Tasks(
    createdAt: json["created_at"],
    acceptanceCriteria: json["acceptance_criteria"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    priority: json["priority"],
    level: json["level"],
    id: json["id"],
    title: json["title"],
    userId: json["user_id"],
    userName: json["users"] != null ? json["users"]["name"] : null,
  );

  Map<String, dynamic> toMap() => {
    "created_at": createdAt,
    "acceptance_criteria": acceptanceCriteria,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "priority": priority,
    "level": level,
    "title": title,
    "user_id": userId,
  };
}
