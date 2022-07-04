import 'package:json_annotation/json_annotation.dart';

part 'geo.g.dart';

/// Represents a fixed latitude, longitude, whereas [GeoPosition] represents a position which may
/// change and therefore includes a timestamp
@JsonSerializable(explicitToJson: true)
class GeoPoint {

  const GeoPoint({required this.latitude, required this.longitude});

  factory GeoPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoPointFromJson(json);
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$GeoPointToJson(this);
}

/// A [GeoPoint] which may change and therefore includes a timestamp
@JsonSerializable(explicitToJson: true)
class GeoPosition {

  const GeoPosition(
      {required this.latitude,
      required this.longitude,
      required this.dateTime});

  factory GeoPosition.fromJson(Map<String, dynamic> json) =>
      _$GeoPositionFromJson(json);
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  Map<String, dynamic> toJson() => _$GeoPositionToJson(this);
}

/// A geographic area represented by a polygon of a minimum of 3 [GeoPoint]s
@JsonSerializable(explicitToJson: true)
class GeoPolygon {

  GeoPolygon({required this.points});

  factory GeoPolygon.fromJson(Map<String, dynamic> json) =>
      _$GeoPolygonFromJson(json);
  final List<GeoPoint> points;

  Map<String, dynamic> toJson() => _$GeoPolygonToJson(this);
}
