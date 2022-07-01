// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condition<T> _$ConditionFromJson<T>(Map<String, dynamic> json) => Condition<T>(
      field: json['field'] as String,
      operator: $enumDecode(_$OperatorEnumMap, json['operator']),
      value: json['value'],
    );

Map<String, dynamic> _$ConditionToJson<T>(Condition<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'operator': _$OperatorEnumMap[instance.operator],
      'value': instance.value,
    };

const _$OperatorEnumMap = {
  Operator.equalTo: 'equalTo',
  Operator.notEqualTo: 'notEqualTo',
  Operator.greaterThan: 'greaterThan',
};

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      Document.fromJson(json['document'] as Map<String, dynamic>),
      (json['conditions'] as List<dynamic>)
          .map((e) => Condition<dynamic>.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'document': instance.document.toJson(),
      'conditions': instance.conditions.map((e) => e.toJson()).toList(),
    };
