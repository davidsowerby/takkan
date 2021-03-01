// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postCode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPostCode _$PPostCodeFromJson(Map<String, dynamic> json) {
  return PPostCode(
    defaultValue: json['defaultValue'] == null
        ? null
        : PostCode.fromJson(json['defaultValue'] as Map<String, dynamic>),
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : PostCodeValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    permissions: json['permissions'] == null
        ? null
        : Permissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PPostCodeToJson(PPostCode instance) => <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

PostCodeValidation _$PostCodeValidationFromJson(Map<String, dynamic> json) {
  return PostCodeValidation(
    method: _$enumDecodeNullable(_$ValidatePostCodeEnumMap, json['method']),
    param: json['param'] == null
        ? null
        : PostCode.fromJson(json['param'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostCodeValidationToJson(PostCodeValidation instance) =>
    <String, dynamic>{
      'method': _$ValidatePostCodeEnumMap[instance.method],
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

const _$ValidatePostCodeEnumMap = {
  ValidatePostCode.isValidForLocale: 'isValidForLocale',
};
