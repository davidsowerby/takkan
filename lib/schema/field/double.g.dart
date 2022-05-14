// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDouble _$FDoubleFromJson(Map<String, dynamic> json) => FDouble(
      defaultValue: (json['defaultValue'] as num?)?.toDouble(),
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => DoubleValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FDoubleToJson(FDouble instance) {
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

DoubleValidation _$DoubleValidationFromJson(Map<String, dynamic> json) =>
    DoubleValidation(
      method: $enumDecode(_$ValidateDoubleEnumMap, json['method']),
      param: (json['param'] as num).toDouble(),
    );

Map<String, dynamic> _$DoubleValidationToJson(DoubleValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateDoubleEnumMap[instance.method],
      'param': instance.param,
    };

const _$ValidateDoubleEnumMap = {
  ValidateDouble.isGreaterThan: 'isGreaterThan',
  ValidateDouble.isLessThan: 'isLessThan',
};
