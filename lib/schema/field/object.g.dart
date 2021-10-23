// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PJsonObject _$PJsonObjectFromJson(Map<String, dynamic> json) => PJsonObject(
      defaultValue: json['defaultValue'] as Map<String, dynamic>?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => ObjectValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

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

ObjectValidation _$ObjectValidationFromJson(Map<String, dynamic> json) =>
    ObjectValidation(
      method: $enumDecode(_$ValidateObjectEnumMap, json['method']),
      param: json['param'],
    );

Map<String, dynamic> _$ObjectValidationToJson(ObjectValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateObjectEnumMap[instance.method],
      'param': instance.param,
    };

const _$ValidateObjectEnumMap = {
  ValidateObject.isNotEmpty: 'isNotEmpty',
};
