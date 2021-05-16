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
    validations: (json['validations'] as List<dynamic>)
        .map((e) => PostCodeValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PPostCodeToJson(PPostCode instance) => <String, dynamic>{
      'validations': instance.validations.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions?.toJson(),
      'defaultValue': instance.defaultValue?.toJson(),
    };

PostCodeValidation _$PostCodeValidationFromJson(Map<String, dynamic> json) {
  return PostCodeValidation(
    method: _$enumDecode(_$ValidatePostCodeEnumMap, json['method']),
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

const _$ValidatePostCodeEnumMap = {
  ValidatePostCode.isValidForLocale: 'isValidForLocale',
};
