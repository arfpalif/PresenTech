import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:presentech/utils/database/database.dart';

List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;
  String? officeName;
  String name;
  String? profilePicture;

  Employee({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    this.officeName,
    required this.name,
    this.profilePicture,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    String? offName;
    if (json["offices"] != null) {
      if (json["offices"] is List && (json["offices"] as List).isNotEmpty) {
        offName = json["offices"][0]["name"];
      } else if (json["offices"] is Map) {
        offName = json["offices"]["name"];
      }
    }

    return Employee(
      id: json["id"] ?? "",
      createdAt: json["created_at"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "employee",
      officeId: json["office_id"] ?? 0,
      officeName: offName ?? json["office_name"],
      name: json["name"] ?? "",
      profilePicture: (json["profile_picture"] != null &&
              json["profile_picture"].toString().isNotEmpty)
          ? json["profile_picture"]
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
    "office_name": officeName,
    "name": name,
    "profile_picture": profilePicture,
  };

  factory Employee.fromDrift(EmployeesTableData data) => Employee(
        id: data.userId,
        createdAt: data.createdAt?.toIso8601String() ?? "",
        email: data.email,
        role: data.roles,
        officeId: data.officeId ?? 0,
        officeName: data.officeName,
        name: data.name ?? "",
        profilePicture: (data.profilePicture != null &&
                data.profilePicture!.isNotEmpty)
            ? data.profilePicture
            : null,
      );

  EmployeesTableCompanion toDrift() => EmployeesTableCompanion(
    userId: Value(id),
    name: Value(name),
    createdAt: Value(DateTime.tryParse(createdAt)),
    email: Value(email),
    roles: Value(role),
    officeId: Value(officeId),
    officeName: Value(officeName),
    profilePicture: Value(profilePicture),
  );
}
