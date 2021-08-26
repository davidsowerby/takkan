// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PString _$PStringFromJson(Map<String, dynamic> json) {
  return PString(
    defaultValue: json['defaultValue'] as String?,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => StringValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PStringToJson(PString instance) =>
    <String, dynamic>{
      'validations': instance.validations.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions?.toJson(),
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

PListString _$PListStringFromJson(Map<String, dynamic> json) {
  return PListString(
    defaultValue: (json['defaultValue'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    required: json['required'] as bool,
    permissions:
        PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PListStringToJson(PListString instance) =>
    <String, dynamic>{
      'permissions': instance.permissions?.toJson(),
      'required': instance.required,
      'defaultValue': instance.defaultValue,
    };

StringValidation _$StringValidationFromJson(Map<String, dynamic> json) {
  return StringValidation(
    method: _$enumDecode(_$ValidateStringEnumMap, json['method']),
    param: json['param'],
  );
}

Map<String, dynamic> _$StringValidationToJson(StringValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateStringEnumMap[instance.method],
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

const _$ValidateStringEnumMap = {
  ValidateString.isLongerThan: 'isLongerThan',
  ValidateString.isShorterThan: 'isShorterThan',
};
