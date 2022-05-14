// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDate _$FDateFromJson(Map<String, dynamic> json) => FDate(
      defaultValue: json['defaultValue'] == null
          ? null
          : DateTime.parse(json['defaultValue'] as String),
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => DateValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FDateToJson(FDate instance) {
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
      method: $enumDecode(_$ValidateDateEnumMap, json['method']),
      param: DateTime.parse(json['param'] as String),
    );

Map<String, dynamic> _$DateValidationToJson(DateValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateDateEnumMap[instance.method],
      'param': instance.param.toIso8601String(),
    };

const _$ValidateDateEnumMap = {
  ValidateDate.isLaterThan: 'isLaterThan',
  ValidateDate.isBefore: 'isBefore',
};
