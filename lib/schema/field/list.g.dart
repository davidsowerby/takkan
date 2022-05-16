// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FList _$FListFromJson(Map<String, dynamic> json) => FList(
      defaultValue: json['defaultValue'] as List<dynamic>?,
      validations: (json['validations'] as List<dynamic>?)
              ?.map((e) => ListValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FListToJson(FList instance) {
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

ListValidation _$ListValidationFromJson(Map<String, dynamic> json) =>
    ListValidation(
      method: $enumDecode(_$ValidateListEnumMap, json['method']),
      param: json['param'] as int? ?? 0,
    );

Map<String, dynamic> _$ListValidationToJson(ListValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateListEnumMap[instance.method],
      'param': instance.param,
    };

const _$ValidateListEnumMap = {
  ValidateList.containsLessThan: 'containsLessThan',
  ValidateList.containsMoreThan: 'containsMoreThan',
};
