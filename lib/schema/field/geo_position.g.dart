// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPosition _$FGeoPositionFromJson(Map<String, dynamic> json) => FGeoPosition(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPosition.fromJson(json['defaultValue'] as Map<String, dynamic>),
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FGeoPositionToJson(FGeoPosition instance) {
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
