// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoPosition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGeoPosition _$PGeoPositionFromJson(Map<String, dynamic> json) => PGeoPosition(
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

Map<String, dynamic> _$PGeoPositionToJson(PGeoPosition instance) {
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
      method: _$enumDecode(_$ValidateGeoPointEnumMap, json['method']),
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
