// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPosition _$FGeoPositionFromJson(Map<String, dynamic> json) => FGeoPosition(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPosition.fromJson(json['defaultValue'] as Map<String, dynamic>),
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) =>
                  GeoPositionValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FGeoPositionToJson(FGeoPosition instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
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

GeoPositionValidation _$GeoPositionValidationFromJson(
        Map<String, dynamic> json) =>
    GeoPositionValidation(
      method: $enumDecode(_$ValidateGeoPointEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : GeoPoint.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoPositionValidationToJson(
        GeoPositionValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoPointEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidateGeoPointEnumMap = {
  ValidateGeoPoint.isValid: 'isValid',
};
