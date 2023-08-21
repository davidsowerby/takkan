// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      constraints: json['constraints'] == null
          ? const []
          : conditionListFromJson(json['constraints'] as List),
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
      'constraints': conditionListToJson(instance.constraints),
    };

QueryDiff _$QueryDiffFromJson(Map<String, dynamic> json) => QueryDiff(
      constraints: nullableConditionListFromJson(json['constraints'] as List?),
      params:
          (json['params'] as List<dynamic>?)?.map((e) => e as String).toList(),
      queryScript: json['queryScript'] as String?,
      returnSingle: json['returnSingle'] as bool?,
      useStream: json['useStream'] as bool?,
      removeQueryScript: json['removeQueryScript'] as bool? ?? false,
    );

Map<String, dynamic> _$QueryDiffToJson(QueryDiff instance) => <String, dynamic>{
      'queryScript': instance.queryScript,
      'params': instance.params,
      'returnSingle': instance.returnSingle,
      'useStream': instance.useStream,
      'removeQueryScript': instance.removeQueryScript,
      'constraints': nullableConditionListToJson(instance.constraints),
    };
