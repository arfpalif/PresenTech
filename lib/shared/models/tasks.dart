  // To parse this JSON data, do
  //
  //     final tasks = tasksFromJson(jsonString);

  import 'dart:convert';

  import 'package:presentech/utils/enum/task_status.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:presentech/utils/database/database.dart';

  List<Tasks> tasksFromJson(String str) =>
      List<Tasks>.from(json.decode(str).map((x) => Tasks.fromJson(x)));

  String tasksToJson(List<Tasks> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    TaskStatus? status;
    int? isSynced;
    String? syncAction;

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
      this.status,
      this.isSynced,
      this.syncAction,
    });


    factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
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
      status: json["status"] == "todo"
          ? TaskStatus.todo
          : json["status"] == "on_progress"
          ? TaskStatus.on_progress
          : json["status"] == "finished"
          ? TaskStatus.finished
          : null,
      isSynced: json["is_synced"],
      syncAction: json["sync_action"],
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
      "title": title,
      "user_id": userId,
      "status": status?.name,
      "is_synced": isSynced,
      "sync_action": syncAction,
    };

    factory Tasks.fromDrift(TasksTableData data) => Tasks(
          id: data.id,
          userId: data.userId,
          title: data.title,
          acceptanceCriteria: data.acceptanceCriteria ?? "",
          startDate: data.startDate ?? DateTime.now(),
          endDate: data.endDate ?? DateTime.now(),
          priority: data.priority ?? "Low",
          level: data.level ?? "Easy",
          status: data.status == "todo"
              ? TaskStatus.todo
              : data.status == "on_progress"
                  ? TaskStatus.on_progress
                  : data.status == "finished"
                      ? TaskStatus.finished
                      : null,
          createdAt: data.createdAt,
          isSynced: data.isSynced,
          syncAction: data.syncAction,
        );

    TasksTableCompanion toDrift() => TasksTableCompanion(
          id: id != null ? Value(id!) : const Value.absent(),
          userId: Value(userId),
          title: Value(title),
          acceptanceCriteria: Value(acceptanceCriteria),
          startDate: Value(startDate),
          endDate: Value(endDate),
          priority: Value(priority),
          level: Value(level),
          status: Value(status?.name),
          createdAt: Value(createdAt),
          isSynced: Value(isSynced ?? 0),
          syncAction: Value(syncAction),
        );
  }
