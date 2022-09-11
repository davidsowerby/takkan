// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_code_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCodeCondition _$PostCodeConditionFromJson(Map<String, dynamic> json) =>
    PostCodeCondition(
      field: json['field'] as String,
      operator: $enumDecode(_$OperatorEnumMap, json['operator']),
      operand: json['operand'],
      forQuery: json['forQuery'] as bool,
    );

Map<String, dynamic> _$PostCodeConditionToJson(PostCodeCondition instance) =>
    <String, dynamic>{
      'field': instance.field,
      'operator': _$OperatorEnumMap[instance.operator]!,
      'operand': instance.operand,
      'forQuery': instance.forQuery,
    };

const _$OperatorEnumMap = {
  Operator.equalTo: 'equalTo',
  Operator.notEqualTo: 'notEqualTo',
  Operator.greaterThan: 'greaterThan',
  Operator.greaterThanOrEqualTo: 'greaterThanOrEqualTo',
  Operator.lessThan: 'lessThan',
  Operator.lessThanOrEqualTo: 'lessThanOrEqualTo',
  Operator.lengthEqualTo: 'lengthEqualTo',
  Operator.lengthGreaterThan: 'lengthGreaterThan',
  Operator.lengthGreaterThanOrEqualTo: 'lengthGreaterThanOrEqualTo',
  Operator.lengthLessThan: 'lengthLessThan',
  Operator.lengthLessThanOrEqualTo: 'lengthLessThanOrEqualTo',
};
