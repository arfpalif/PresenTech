// To parse this JSON data, do
//
//     final UserProfile = UserProfileFromJson(jsonString);

import 'dart:convert';

List<UserProfile> userProfileFromJson(String str) => List<UserProfile>.from(
  json.decode(str).map((x) => UserProfile.fromJson(x)),
);

String userProfileToJson(List<UserProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfile {
  String id;
  String createdAt;
  String email;
  String role;
  int officeId;
  String name;
  String? profilePicture;
  String? localImagePath;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.role,
    required this.officeId,
    required this.name,
    this.profilePicture,
    this.localImagePath,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    createdAt: json["created_at"],
    email: json["email"],
    role: json["role"],
    officeId: json["office_id"],
    name: json["name"],
    profilePicture: json["profile_picture"],
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
    "local_image_path": localImagePath,
  };
}
