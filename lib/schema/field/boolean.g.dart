// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBoolean _$PBooleanFromJson(Map<String, dynamic> json) {
  return PBoolean(
    defaultValue: json['defaultValue'] as bool?,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => BooleanValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PBooleanToJson(PBoolean instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue);
  return val;
}

BooleanValidation _$BooleanValidationFromJson(Map<String, dynamic> json) {
  return BooleanValidation(
    method: _$enumDecode(_$ValidateBooleanEnumMap, json['method']),
    param: json['param'] as bool?,
  );
}

Map<String, dynamic> _$BooleanValidationToJson(BooleanValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateBooleanEnumMap[instance.method],
      'param': instance.param,
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

const _$ValidateBooleanEnumMap = {
  ValidateBoolean.isTrue: 'isTrue',
  ValidateBoolean.isFalse: 'isFalse',
};
