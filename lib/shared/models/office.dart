import 'dart:convert';

List<Office> officeFromJson(String str) =>
    List<Office>.from(json.decode(str).map((x) => Office.fromJson(x)));

String officeToJson(List<Office> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Office {
  int id;
  String address;
  String name;
  double longitude;
  double latitude;
  double radius;
  DateTime? createdAt;
  String? startTime;
  String? endTime;

  Office({
    required this.id,
    required this.address,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.radius,
    this.createdAt,
    this.startTime,
    this.endTime,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json["id"],
        address: json["address"],
        name: json["name"],
        longitude: json["longitude"]?.toDouble() ?? 0.0,
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        radius: json["radius"]?.toDouble() ?? 0.0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
        "created_at": createdAt?.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
      };
}
