// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPointer _$PPointerFromJson(Map<String, dynamic> json) => PPointer(
      defaultValue: json['defaultValue'] == null
          ? null
          : Pointer.fromJson(json['defaultValue'] as Map<String, dynamic>),
      targetClass: json['targetClass'] as String,
      validations: (json['validations'] as List<dynamic>?)
              ?.map(
                  (e) => PointerValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$PPointerToJson(PPointer instance) {
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
  val['targetClass'] = instance.targetClass;
  return val;
}

PointerValidation _$PointerValidationFromJson(Map<String, dynamic> json) =>
    PointerValidation(
      method: $enumDecode(_$ValidatePointerEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : Pointer.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PointerValidationToJson(PointerValidation instance) =>
    <String, dynamic>{
      'method': _$ValidatePointerEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidatePointerEnumMap = {
  ValidatePointer.isValid: 'isValid',
};
