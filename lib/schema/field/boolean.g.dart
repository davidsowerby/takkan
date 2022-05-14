// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FBoolean _$FBooleanFromJson(Map<String, dynamic> json) => FBoolean(
      defaultValue: json['defaultValue'] as bool?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map(
                  (e) => BooleanValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FBooleanToJson(FBoolean instance) {
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

BooleanValidation _$BooleanValidationFromJson(Map<String, dynamic> json) =>
    BooleanValidation(
      method: $enumDecode(_$ValidateBooleanEnumMap, json['method']),
      param: json['param'] as bool?,
    );

Map<String, dynamic> _$BooleanValidationToJson(BooleanValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateBooleanEnumMap[instance.method],
      'param': instance.param,
    };

const _$ValidateBooleanEnumMap = {
  ValidateBoolean.isTrue: 'isTrue',
  ValidateBoolean.isFalse: 'isFalse',
};
