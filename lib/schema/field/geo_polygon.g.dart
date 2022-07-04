// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_polygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPolygon _$FGeoPolygonFromJson(Map<String, dynamic> json) => FGeoPolygon(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPolygon.fromJson(json['defaultValue'] as Map<String, dynamic>),
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FGeoPolygonToJson(FGeoPolygon instance) {
  final val = <String, dynamic>{
    'validation': instance.validation,
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue?.toJson());
  return val;
}
