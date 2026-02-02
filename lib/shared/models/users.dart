// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;
  String name;
  dynamic profilePicture;
  int? isSynced;
  String? syncAction;
  String? localImagePath;

  Users({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    required this.name,
    required this.profilePicture,
    this.isSynced,
    this.syncAction,
    this.localImagePath,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"] ?? "",
    createdAt: json["created_at"] ?? "",
    email: json["email"] ?? "",
    role: json["role"] ?? "",
    officeId: json["office_id"] is int ? json["office_id"] : (int.tryParse(json["office_id"]?.toString() ?? "") ?? 0),
    name: json["name"] ?? "",
    profilePicture: json["profile_picture"],
    isSynced: json["is_synced"],
    syncAction: json["sync_action"],
    localImagePath: json["local_image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
    "name": name,
    "profile_picture": profilePicture,
    "is_synced": isSynced,
    "sync_action": syncAction,
    "local_image_path": localImagePath,
  };
}
