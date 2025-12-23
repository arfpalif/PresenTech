// To parse this JSON data, do
//
//     final UserProfile = UserProfileFromJson(jsonString);

import 'dart:convert';

List<UserProfile> UserProfileFromJson(String str) => List<UserProfile>.from(
  json.decode(str).map((x) => UserProfile.fromJson(x)),
);

String UserProfileToJson(List<UserProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfile {
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;
  String name;
  String profilePicture;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    required this.name,
    required this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    createdAt: json["created_at"],
    email: json["email"],
    role: json["role"],
    officeId: json["office_id"],
    name: json["name"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "email": email,
    "role": role,
    "office_id": officeId,
    "name": name,
    "profile_picture": profilePicture,
  };
}
