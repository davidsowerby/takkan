// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pGeoLocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoLocation _$PGeoLocationFromJson(Map<String, dynamic> json) {
  return PGeoLocation(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoLocation.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List<dynamic>)
        .map((e) => GeoLocationValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PGeoLocationToJson(PGeoLocation instance) =>
    <String, dynamic>{
      'validations': instance.validations.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions?.toJson(),
      'required': instance.required,
      'defaultValue': instance.defaultValue?.toJson(),
    };

GeoLocationValidation _$GeoLocationValidationFromJson(
    Map<String, dynamic> json) {
  return GeoLocationValidation(
    method: _$enumDecode(_$ValidateGeoLocationEnumMap, json['method']),
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

const _$ValidateGeoLocationEnumMap = {
  ValidateGeoLocation.isValid: 'isValid',
};
