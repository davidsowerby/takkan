// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoPolygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoPolygon _$PGeoPolygonFromJson(Map<String, dynamic> json) => PGeoPolygon(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPolygon.fromJson(json['defaultValue'] as Map<String, dynamic>),
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) =>
                  GeoPolygonValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$PGeoPolygonToJson(PGeoPolygon instance) {
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

GeoPolygonValidation _$GeoPolygonValidationFromJson(
        Map<String, dynamic> json) =>
    GeoPolygonValidation(
      method: $enumDecode(_$ValidateGeoPointEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : GeoPoint.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoPolygonValidationToJson(
        GeoPolygonValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoPointEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidateGeoPointEnumMap = {
  ValidateGeoPoint.isValid: 'isValid',
};
