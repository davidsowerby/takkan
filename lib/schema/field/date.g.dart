// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDate _$PDateFromJson(Map<String, dynamic> json) => PDate(
      defaultValue: json['defaultValue'] == null
          ? null
          : DateTime.parse(json['defaultValue'] as String),
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => DateValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$PDateToJson(PDate instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue?.toIso8601String());
  return val;
}

DateValidation _$DateValidationFromJson(Map<String, dynamic> json) =>
    DateValidation(
      method: _$enumDecode(_$ValidateDateEnumMap, json['method']),
      param: DateTime.parse(json['param'] as String),
    );

Map<String, dynamic> _$DateValidationToJson(DateValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateDateEnumMap[instance.method],
      'param': instance.param.toIso8601String(),
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

const _$ValidateDateEnumMap = {
  ValidateDate.isLaterThan: 'isLaterThan',
  ValidateDate.isBefore: 'isBefore',
};
