// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoPosition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoPosition _$GeoPositionFromJson(Map<String, dynamic> json) {
  return GeoPosition(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$GeoPositionToJson(GeoPosition instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) {
  return GeoLocation(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$GeoLocationToJson(GeoLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
