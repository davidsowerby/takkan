// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PString _$PStringFromJson(Map<String, dynamic> json) {
  return PString(
    defaultValue: json['defaultValue'] as String,
    validations: (json['validations'] as List)
        ?.map((e) => e == null
            ? null
            : StringValidation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PStringToJson(PString instance) => <String, dynamic>{
      'validations': instance.validations?.map((e) => e?.toJson())?.toList(),
      'defaultValue': instance.defaultValue,
    };

PListString _$PListStringFromJson(Map<String, dynamic> json) {
  return PListString(
    defaultValue:
        (json['defaultValue'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PListStringToJson(PListString instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

StringValidation _$StringValidationFromJson(Map<String, dynamic> json) {
  return StringValidation(
    method: _$enumDecodeNullable(_$ValidateStringEnumMap, json['method']),
    param: json['param'],
  );
}

Map<String, dynamic> _$StringValidationToJson(StringValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateStringEnumMap[instance.method],
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

const _$ValidateStringEnumMap = {
  ValidateString.isLongerThan: 'isLongerThan',
  ValidateString.isShorterThan: 'isShorterThan',
};
