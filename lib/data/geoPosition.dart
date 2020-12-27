import 'package:json_annotation/json_annotation.dart';

part 'geoPosition.g.dart';

/// Represents a fixed latitude, longitude, whereas [GeoLocation] represents a position which may
/// change and therefore includes a timestamp
@JsonSerializable(nullable: true, explicitToJson: true)
class GeoPosition  {
  final double latitude;
  final double longitude;

  const GeoPosition({this.latitude, this.longitude});

  factory GeoPosition.fromJson(Map<String, dynamic> json) => _$GeoPositionFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPositionToJson(this);
}

/// A geo-position which may change and therefore includes a timestamp, unlike [GeoPosition]
/// which is expected to be static
@JsonSerializable(nullable: true, explicitToJson: true)
class GeoLocation  {
  final double latitude;
  final double longitude;
  const GeoLocation({this.latitude, this.longitude}) ;

  factory GeoLocation.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationFromJson(json);

  Map<String, dynamic> toJson() => _$GeoLocationToJson(this);
}