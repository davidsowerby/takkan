// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestQuery _$PRestQueryFromJson(Map<String, dynamic> json) => PRestQuery(
      path: json['path'] as String?,
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      paramsAsPath: json['paramsAsPath'] as bool? ?? true,
      queryName: json['queryName'] as String,
      documentSchema: json['documentSchema'] as String,
      params: (json['params'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      returnType:
          $enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']) ??
              QueryReturnType.futureList,
    );

Map<String, dynamic> _$PRestQueryToJson(PRestQuery instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'queryName': instance.queryName,
      'documentSchema': instance.documentSchema,
      'paramsAsPath': instance.paramsAsPath,
      'params': instance.params,
      'path': instance.path,
    };

const _$QueryReturnTypeEnumMap = {
  QueryReturnType.futureItem: 'futureItem',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamItem: 'streamItem',
  QueryReturnType.streamList: 'streamList',
  QueryReturnType.futureDocument: 'futureDocument',
  QueryReturnType.streamDocument: 'streamDocument',
};
