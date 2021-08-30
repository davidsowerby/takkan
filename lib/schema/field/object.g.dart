// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PJsonObject _$PJsonObjectFromJson(Map<String, dynamic> json) {
  return PJsonObject(
    defaultValue: json['defaultValue'] as Map<String, dynamic>?,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => ObjectValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PJsonObjectToJson(PJsonObject instance) {
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

ObjectValidation _$ObjectValidationFromJson(Map<String, dynamic> json) {
  return ObjectValidation(
    method: _$enumDecode(_$ValidateObjectEnumMap, json['method']),
    param: json['param'],
  );
}

Map<String, dynamic> _$ObjectValidationToJson(ObjectValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateObjectEnumMap[instance.method],
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

const _$ValidateObjectEnumMap = {
  ValidateObject.isNotEmpty: 'isNotEmpty',
};
