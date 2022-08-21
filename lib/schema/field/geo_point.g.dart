// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPoint _$FGeoPointFromJson(Map<String, dynamic> json) => FGeoPoint(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPoint.fromJson(json['defaultValue'] as Map<String, dynamic>),
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FGeoPointToJson(FGeoPoint instance) {
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
