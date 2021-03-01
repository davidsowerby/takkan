// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDate _$PDateFromJson(Map<String, dynamic> json) {
  return PDate(
    defaultValue: json['defaultValue'] == null
        ? null
        : DateTime.parse(json['defaultValue'] as String),
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : DateValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PDateToJson(PDate instance) => <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue?.toIso8601String(),
    };

DateValidation _$DateValidationFromJson(Map<String, dynamic> json) {
  return DateValidation(
    method: _$enumDecodeNullable(_$ValidateDateEnumMap, json['method']),
    param:
        json['param'] == null ? null : DateTime.parse(json['param'] as String),
  );
}

Map<String, dynamic> _$DateValidationToJson(DateValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateDateEnumMap[instance.method],
      'param': instance.param?.toIso8601String(),
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

const _$ValidateDateEnumMap = {
  ValidateDate.isLaterThan: 'isLaterThan',
  ValidateDate.isBefore: 'isBefore',
};
