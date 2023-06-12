// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      conditions: json['conditions'] == null
          ? const []
          : conditionListFromJson(json['conditions'] as List?),
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
      'conditions': conditionListToJson(instance.conditions),
    };
