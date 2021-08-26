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
    validations: (json['validations'] as List<dynamic>)
        .map((e) => PointerValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    permissions: json['permissions'] == null
        ? null
        : PPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PPointerToJson(PPointer instance) =>
    <String, dynamic>{
      'validations': instance.validations.map((e) => e.toJson()).toList(),
      'permissions': instance.permissions?.toJson(),
      'required': instance.required,
      'defaultValue': instance.defaultValue?.toJson(),
    };

PointerValidation _$PointerValidationFromJson(Map<String, dynamic> json) {
  return PointerValidation(
    method: _$enumDecode(_$ValidatePointerEnumMap, json['method']),
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

const _$ValidatePointerEnumMap = {
  ValidatePointer.isValid: 'isValid',
};
