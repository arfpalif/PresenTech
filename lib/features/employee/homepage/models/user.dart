import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int idx;
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;

  User({
    required this.idx,
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    idx: json["idx"],
    id: json["id"],
    createdAt: json["created_at"],
    email: json["email"],
    role: json["role"],
    officeId: json["office_id"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "id": id,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
  };
}
