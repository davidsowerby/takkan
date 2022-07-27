// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_combiner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) =>
              const ConditionConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      params: (json['params'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'params': instance.params,
      'conditions':
          instance.conditions.map(const ConditionConverter().toJson).toList(),
    };
