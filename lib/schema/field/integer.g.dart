// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PInteger _$PIntegerFromJson(Map<String, dynamic> json) {
  return PInteger(
    defaultValue: json['defaultValue'] as int,
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : IntegerValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PIntegerToJson(PInteger instance) => <String, dynamic>{
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue,
    };

IntegerValidation _$IntegerValidationFromJson(Map<String, dynamic> json) {
  return IntegerValidation(
    method: _$enumDecodeNullable(_$ValidateIntegerEnumMap, json['method']),
    param: json['param'] as int,
  );
}

Map<String, dynamic> _$IntegerValidationToJson(IntegerValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateIntegerEnumMap[instance.method],
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

const _$ValidateIntegerEnumMap = {
  ValidateInteger.isGreaterThan: 'isGreaterThan',
  ValidateInteger.isLessThan: 'isLessThan',
};
