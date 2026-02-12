import 'dart:convert';

import 'package:drift/drift.dart' as d;
import 'package:presentech/utils/database/database.dart';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String id;
  String name;
  String createdAt;
  String email;
  String role;
  int officeId;
  String? profile_picture;
  String? localImagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    this.profile_picture,
    this.localImagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    createdAt: json["created_at"] ?? "",
    email: json["email"] ?? "",
    role: json["role"] ?? "employee",
    officeId: json["office_id"] ?? 0,
    profile_picture: (json["profile_picture"] != null &&
            json["profile_picture"].toString().isNotEmpty)
        ? json["profile_picture"]
        : null,
    localImagePath: json["local_image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
    "profile_picture": profile_picture,
    "local_image_path": localImagePath,
  };

  factory UserModel.fromDrift(EmployeesTableData data) => UserModel(
    id: data.userId,
    name: data.name.toString(),
    createdAt: data.createdAt?.toIso8601String() ?? "",
    email: data.email,
    role: data.roles,
    officeId: data.officeId ?? 0,
    profile_picture: (data.profilePicture != null &&
            data.profilePicture!.isNotEmpty)
        ? data.profilePicture
        : null,
  );

  EmployeesTableCompanion toDrift() => EmployeesTableCompanion(
    userId: d.Value(id),
    name: d.Value(name),
    createdAt: d.Value(DateTime.tryParse(createdAt)),
    email: d.Value(email),
    roles: d.Value(role),
    officeId: d.Value(officeId),
    profilePicture: d.Value(profile_picture),
  );
}
