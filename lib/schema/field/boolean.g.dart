// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBoolean _$PBooleanFromJson(Map<String, dynamic> json) {
  return PBoolean(
    defaultValue: json['defaultValue'] as bool,
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : BooleanValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBooleanToJson(PBoolean instance) => <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue,
    };

BooleanValidation _$BooleanValidationFromJson(Map<String, dynamic> json) {
  return BooleanValidation(
    method: _$enumDecodeNullable(_$ValidateBooleanEnumMap, json['method']),
    param: json['param'] as bool,
  );
}

Map<String, dynamic> _$BooleanValidationToJson(BooleanValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateBooleanEnumMap[instance.method],
      'param': instance.param,
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

const _$ValidateBooleanEnumMap = {
  ValidateBoolean.isTrue: 'isTrue',
  ValidateBoolean.isFalse: 'isFalse',
};
