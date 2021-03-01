// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDouble _$PDoubleFromJson(Map<String, dynamic> json) {
  return PDouble(
    defaultValue: (json['defaultValue'] as num)?.toDouble(),
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : DoubleValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PDoubleToJson(PDouble instance) => <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue,
    };

DoubleValidation _$DoubleValidationFromJson(Map<String, dynamic> json) {
  return DoubleValidation(
    method: _$enumDecodeNullable(_$ValidateDoubleEnumMap, json['method']),
    param: (json['param'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DoubleValidationToJson(DoubleValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateDoubleEnumMap[instance.method],
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

const _$ValidateDoubleEnumMap = {
  ValidateDouble.isGreaterThan: 'isGreaterThan',
  ValidateDouble.isLessThan: 'isLessThan',
};
