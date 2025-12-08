import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  int? id;
  String createdAt;
  String acceptanceCriteria;
  DateTime startDate;
  DateTime endDate;
  String priority;
  String level;

  Task({
    this.id,
    required this.createdAt,
    required this.acceptanceCriteria,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.level,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    createdAt: json["created_at"],
    acceptanceCriteria: json["acceptance_criteria"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    priority: json["priority"],
    level: json["level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "acceptance_criteria": acceptanceCriteria,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "priority": priority,
    "level": level,
  };

  Map<String, dynamic> toInsertJson() => {
    "acceptance_criteria": acceptanceCriteria,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "priority": priority,
    "level": level,
  };
}
