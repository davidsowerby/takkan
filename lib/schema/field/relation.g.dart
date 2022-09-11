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
      constraints: (json['constraints'] as List<dynamic>?)
              ?.map(
                  (e) => RelationCondition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      required: json['required'] as bool? ?? false,
      isReadOnly:
          $enumDecodeNullable(_$IsReadOnlyEnumMap, json['isReadOnly']) ??
              IsReadOnly.inherited,
      validation: json['validation'] as String?,
    );

Map<String, dynamic> _$FRelationToJson(FRelation instance) => <String, dynamic>{
      'isReadOnly': _$IsReadOnlyEnumMap[instance.isReadOnly]!,
      'constraints': instance.constraints.map((e) => e.toJson()).toList(),
      'validation': instance.validation,
      'required': instance.required,
      'defaultValue': instance.defaultValue?.toJson(),
      'targetClass': instance.targetClass,
    };

const _$IsReadOnlyEnumMap = {
  IsReadOnly.yes: 'yes',
  IsReadOnly.no: 'no',
  IsReadOnly.inherited: 'inherited',
};
