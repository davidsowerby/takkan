// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_combiner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      (json['conditions'] as List<dynamic>)
          .map((e) =>
              const ConditionConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'conditions':
          instance.conditions.map(const ConditionConverter().toJson).toList(),
    };
