import 'dart:convert';

List<UserModel> UserModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String UserModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  int idx;
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;
  String profile_picture;

  UserModel({
    required this.idx,
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    required this.profile_picture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    idx: json["idx"],
    id: json["id"],
    createdAt: json["created_at"],
    email: json["email"],
    role: json["role"],
    officeId: json["office_id"],
    profile_picture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "id": id,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
    "profile_picture": profile_picture,
  };
}
