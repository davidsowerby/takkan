// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FRelation _$FRelationFromJson(Map<String, dynamic> json) => FRelation(
      targetClass: json['targetClass'] as String,
      defaultValue: json['defaultValue'] == null
          ? null
          : Relation.fromJson(json['defaultValue'] as Map<String, dynamic>),
      required: json['required'] as bool? ?? false,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FRelationToJson(FRelation instance) {
  final val = <String, dynamic>{
    'validation': instance.validation,
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
