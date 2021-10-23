// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postCode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPostCode _$PPostCodeFromJson(Map<String, dynamic> json) => PPostCode(
      defaultValue: json['defaultValue'] == null
          ? null
          : PostCode.fromJson(json['defaultValue'] as Map<String, dynamic>),
      validations: (json['validations'] as List<dynamic>?)
              ?.map(
                  (e) => PostCodeValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$PPostCodeToJson(PPostCode instance) {
  final val = <String, dynamic>{
    'validations': instance.validations.map((e) => e.toJson()).toList(),
    'required': instance.required,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('defaultValue', instance.defaultValue?.toJson());
  return val;
}

PostCodeValidation _$PostCodeValidationFromJson(Map<String, dynamic> json) =>
    PostCodeValidation(
      method: $enumDecode(_$ValidatePostCodeEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : PostCode.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostCodeValidationToJson(PostCodeValidation instance) =>
    <String, dynamic>{
      'method': _$ValidatePostCodeEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidatePostCodeEnumMap = {
  ValidatePostCode.isValidForLocale: 'isValidForLocale',
};
