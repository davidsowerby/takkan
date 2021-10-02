// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PInteger _$PIntegerFromJson(Map<String, dynamic> json) {
  return PInteger(
    defaultValue: json['defaultValue'] as int?,
    validations: (json['validations'] as List<dynamic>)
        .map((e) => IntegerValidation.fromJson(e as Map<String, dynamic>))
        .toList(),
    required: json['required'] as bool,
  );
}

Map<String, dynamic> _$PIntegerToJson(PInteger instance) {
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

IntegerValidation _$IntegerValidationFromJson(Map<String, dynamic> json) {
  return IntegerValidation(
    method: _$enumDecode(_$ValidateIntegerEnumMap, json['method']),
    param: json['param'] as int,
  );
}

Map<String, dynamic> _$IntegerValidationToJson(IntegerValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateIntegerEnumMap[instance.method],
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

const _$ValidateIntegerEnumMap = {
  ValidateInteger.greaterThan: 'greaterThan',
  ValidateInteger.lessThan: 'lessThan',
};
