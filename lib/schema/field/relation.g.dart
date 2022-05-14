// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FRelation _$FRelationFromJson(Map<String, dynamic> json) => FRelation(
      defaultValue: json['defaultValue'] == null
          ? null
          : Relation.fromJson(json['defaultValue'] as Map<String, dynamic>),
      targetClass: json['targetClass'] as String,
      validations: (json['validations'] as List<dynamic>?)
              ?.map(
                  (e) => RelationValidation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$FRelationToJson(FRelation instance) {
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

RelationValidation _$RelationValidationFromJson(Map<String, dynamic> json) =>
    RelationValidation(
      method: $enumDecode(_$ValidateRelationEnumMap, json['method']),
      param: json['param'] == null
          ? null
          : Relation.fromJson(json['param'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelationValidationToJson(RelationValidation instance) =>
    <String, dynamic>{
      'method': _$ValidateRelationEnumMap[instance.method],
      'param': instance.param?.toJson(),
    };

const _$ValidateRelationEnumMap = {
  ValidateRelation.isValid: 'isValid',
};
