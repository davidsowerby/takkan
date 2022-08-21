// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => const ConditionConverter()
                  .fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      params: (json['params'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      queryScript: json['queryScript'] as String?,
      returnSingle: json['returnSingle'] as bool? ?? false,
      useStream: json['useStream'] as bool? ?? false,
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'queryScript': instance.queryScript,
      'params': instance.params,
      'returnSingle': instance.returnSingle,
      'useStream': instance.useStream,
      'conditions':
          instance.conditions.map(const ConditionConverter().toJson).toList(),
    };
