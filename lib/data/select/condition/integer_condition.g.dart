// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integer_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntegerCondition _$IntegerConditionFromJson(Map<String, dynamic> json) =>
    IntegerCondition(
      field: json['field'] as String,
      operator: $enumDecode(_$OperatorEnumMap, json['operator']),
      reference: json['reference'],
    );

Map<String, dynamic> _$IntegerConditionToJson(IntegerCondition instance) =>
    <String, dynamic>{
      'field': instance.field,
      'operator': _$OperatorEnumMap[instance.operator]!,
      'reference': instance.reference,
    };

const _$OperatorEnumMap = {
  Operator.equalTo: 'equalTo',
  Operator.notEqualTo: 'notEqualTo',
  Operator.greaterThan: 'greaterThan',
  Operator.lessThan: 'lessThan',
  Operator.longerThan: 'longerThan',
  Operator.shorterThan: 'shorterThan',
};
