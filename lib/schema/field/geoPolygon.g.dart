// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoPolygon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoPolygon _$PGeoPolygonFromJson(Map<String, dynamic> json) {
  return PGeoPolygon(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoPolygon.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List<dynamic>)
        .map((e) => GeoPolygonValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PGeoPolygonToJson(PGeoPolygon instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'permissions': instance.permissions?.toJson(),
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

GeoPolygonValidation _$GeoPolygonValidationFromJson(Map<String, dynamic> json) {
  return GeoPolygonValidation(
    method: _$enumDecode(_$ValidateGeoPointEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : GeoPoint.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeoPolygonValidationToJson(
        GeoPolygonValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoPointEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ValidateGeoPointEnumMap = {
  ValidateGeoPoint.isValid: 'isValid',
};
