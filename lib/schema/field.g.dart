// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBoolean _$PBooleanFromJson(Map<String, dynamic> json) {
  return PBoolean(
    defaultValue: json['defaultValue'] as bool,
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PBooleanToJson(PBoolean instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue,
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

const _$ValidationEnumMap = {
  Validation.isAlpha: 'isAlpha',
  Validation.isInt: 'isInt',
  Validation.isDouble: 'isDouble',
};

PInteger _$PIntegerFromJson(Map<String, dynamic> json) {
  return PInteger(
    defaultValue: json['defaultValue'] as int,
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PIntegerToJson(PInteger instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue,
    };

PString _$PStringFromJson(Map<String, dynamic> json) {
  return PString(
    defaultValue: json['defaultValue'] as String,
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PStringToJson(PString instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue,
    };

PDate _$PDateFromJson(Map<String, dynamic> json) {
  return PDate(
    defaultValue: json['defaultValue'] == null
        ? null
        : DateTime.parse(json['defaultValue'] as String),
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PDateToJson(PDate instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue?.toIso8601String(),
    };

PPointer _$PPointerFromJson(Map<String, dynamic> json) {
  return PPointer(
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PPointerToJson(PPointer instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
    };

PDouble _$PDoubleFromJson(Map<String, dynamic> json) {
  return PDouble(
    defaultValue: (json['defaultValue'] as num)?.toDouble(),
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PDoubleToJson(PDouble instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue,
    };

PGeoPosition _$PGeoPositionFromJson(Map<String, dynamic> json) {
  return PGeoPosition(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoPosition.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PGeoPositionToJson(PGeoPosition instance) =>
    <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

PPostCode _$PPostCodeFromJson(Map<String, dynamic> json) {
  return PPostCode(
    defaultValue: json['defaultValue'] == null
        ? null
        : PostCode.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PPostCodeToJson(PPostCode instance) => <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

PGeoLocation _$PGeoLocationFromJson(Map<String, dynamic> json) {
  return PGeoLocation(
    defaultValue: json['defaultValue'] == null
        ? null
        : GeoLocation.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ValidationEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$PGeoLocationToJson(PGeoLocation instance) =>
    <String, dynamic>{
      'validations':
          instance.validations?.map((e) => _$ValidationEnumMap[e])?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };
