// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoLocation _$PGeoLocationFromJson(Map<String, dynamic> json) {
  return PGeoLocation(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoLocation.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : GeoLocationValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    permissions: json['permissions'] == null
        ? null
        : Permissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PGeoLocationToJson(PGeoLocation instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

GeoLocationValidation _$GeoLocationValidationFromJson(
    Map<String, dynamic> json) {
  return GeoLocationValidation(
    method: _$enumDecodeNullable(_$ValidateGeoLocationEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : GeoLocation.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeoLocationValidationToJson(
        GeoLocationValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateGeoLocationEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ValidateGeoLocationEnumMap = {
  ValidateGeoLocation.isValid: 'isValid',
};
