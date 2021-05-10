// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPointer _$PPointerFromJson(Map<String, dynamic> json) {
  return PPointer(
    defaultValue: json['defaultValue'] == null
        ? null
        : Pointer.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : PointerValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PPointerToJson(PPointer instance) => <String, dynamic>{
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

PointerValidation _$PointerValidationFromJson(Map<String, dynamic> json) {
  return PointerValidation(
    method: _$enumDecodeNullable(_$ValidatePointerEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : Pointer.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PointerValidationToJson(PointerValidation instance) =>
    <String, dynamic>{
      'method': _$ValidatePointerEnumMap[instance.method],
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

const _$ValidatePointerEnumMap = {
  ValidatePointer.isValid: 'isValid',
};
