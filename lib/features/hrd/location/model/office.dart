import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:presentech/utils/database/database.dart';

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
  bool isSynced;
  String? syncAction;

  Office({
    required this.id,
    required this.address,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.radius,
    this.isSynced = true,
    this.syncAction,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json["id"] is String ? int.parse(json["id"]) : (json["id"] ?? 0),
        address: json["address"] ?? "",
        name: json["name"] ?? "",
        longitude: json["longitude"]?.toDouble() ?? 0.0,
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        radius: json["radius"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
      };

  factory Office.fromDrift(LocationsTableData data) => Office(
        id: data.id,
        name: data.name ?? "",
        address: data.address ?? "",
        latitude: data.latitude ?? 0.0,
        longitude: data.longitude ?? 0.0,
        radius: data.radius ?? 0.0,
        isSynced: data.isSynced,
        syncAction: data.syncAction,
      );

  LocationsTableCompanion toDrift() => LocationsTableCompanion(
        id: Value(id),
        name: Value(name),
        address: Value(address),
        latitude: Value(latitude),
        longitude: Value(longitude),
        radius: Value(radius),
        isSynced: Value(isSynced),
        syncAction: Value(syncAction),
      );
}
