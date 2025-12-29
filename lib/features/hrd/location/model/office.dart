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
  int radius;

  Office({
    required this.id,
    required this.address,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.radius,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    id: json["id"],
    address: json["address"],
    name: json["name"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
    radius: json["radius"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "name": name,
    "longitude": longitude,
    "latitude": latitude,
    "radius": radius,
  };
}
