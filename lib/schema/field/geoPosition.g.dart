// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoPosition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoPosition _$PGeoPositionFromJson(Map<String, dynamic> json) {
  return PGeoPosition(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoPosition.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List<dynamic>)
        .map((e) => GeoPositionValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PGeoPositionToJson(PGeoPosition instance) =>
    <String, dynamic>{
      'validations': instance.validations.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions?.toJson(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

GeoPositionValidation _$GeoPositionValidationFromJson(
    Map<String, dynamic> json) {
  return GeoPositionValidation(
    method: _$enumDecode(_$ValidateGeoPositionEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : GeoPosition.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeoPositionValidationToJson(
        GeoPositionValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoPositionEnumMap[instance.method],
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

const _$ValidateGeoPositionEnumMap = {
  ValidateGeoPosition.isValid: 'isValid',
};
