// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FGeoPoint _$FGeoPointFromJson(Map<String, dynamic> json) => FGeoPoint(
      defaultValue: json['defaultValue'] == null
          ? null
          : GeoPoint.fromJson(json['defaultValue'] as Map<String, dynamic>),
      validations: (json['validations'] as List<dynamic>?)
              ?.map(
                  (e) => GeoPointValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FGeoPointToJson(FGeoPoint instance) {
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

GeoPointValidation _$GeoPointValidationFromJson(Map<String, dynamic> json) =>
    GeoPointValidation(
      method: $enumDecode(_$ValidateGeoPointEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : GeoPoint.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoPointValidationToJson(GeoPointValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoPointEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidateGeoPointEnumMap = {
  ValidateGeoPoint.isValid: 'isValid',
};
