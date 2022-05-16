// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQLQuery _$GraphQLQueryFromJson(Map<String, dynamic> json) => GraphQLQuery(
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documentSchema: json['documentSchema'] as String,
      queryScript: json['queryScript'] as String,
      queryName: json['queryName'] as String,
      returnType:
          $enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']) ??
              QueryReturnType.futureItem,
    );

Map<String, dynamic> _$GraphQLQueryToJson(GraphQLQuery instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'queryName': instance.queryName,
      'documentSchema': instance.documentSchema,
      'queryScript': instance.queryScript,
    };

const _$QueryReturnTypeEnumMap = {
  QueryReturnType.futureItem: 'futureItem',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamItem: 'streamItem',
  QueryReturnType.streamList: 'streamList',
  QueryReturnType.futureDocument: 'futureDocument',
  QueryReturnType.streamDocument: 'streamDocument',
};

PQuery _$PQueryFromJson(Map<String, dynamic> json) => PQuery(
      fields: json['fields'] as String? ?? '',
      types: (json['types'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      queryName: json['queryName'] as String,
      documentSchema: json['documentSchema'] as String,
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      returnType:
          $enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']) ??
              QueryReturnType.futureItem,
    );

Map<String, dynamic> _$PQueryToJson(PQuery instance) => <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'queryName': instance.queryName,
      'documentSchema': instance.documentSchema,
      'fields': instance.fields,
      'types': instance.types,
    };

GetDocument _$GetDocumentFromJson(Map<String, dynamic> json) => GetDocument(
      fieldSelector: json['fieldSelector'] == null
          ? const FieldSelector()
          : FieldSelector.fromJson(
              json['fieldSelector'] as Map<String, dynamic>),
      documentId:
          DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
      queryName: json['queryName'] as String?,
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetDocumentToJson(GetDocument instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'queryName': instance.queryName,
      'documentId': instance.documentId.toJson(),
      'fieldSelector': instance.fieldSelector.toJson(),
    };

GetStream _$GetStreamFromJson(Map<String, dynamic> json) => GetStream(
      queryName: json['queryName'] as String?,
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documentId:
          DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetStreamToJson(GetStream instance) => <String, dynamic>{
      'propertyReferences': instance.propertyReferences,
      'queryName': instance.queryName,
      'documentId': instance.documentId.toJson(),
    };
