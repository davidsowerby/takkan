// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQLQuery _$PGraphQLQueryFromJson(Map<String, dynamic> json) =>
    PGraphQLQuery(
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

Map<String, dynamic> _$PGraphQLQueryToJson(PGraphQLQuery instance) =>
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

PPQuery _$PPQueryFromJson(Map<String, dynamic> json) => PPQuery(
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

Map<String, dynamic> _$PPQueryToJson(PPQuery instance) => <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'queryName': instance.queryName,
      'documentSchema': instance.documentSchema,
      'fields': instance.fields,
      'types': instance.types,
    };

PGetDocument _$PGetDocumentFromJson(Map<String, dynamic> json) => PGetDocument(
      fieldSelector: json['fieldSelector'] == null
          ? const FieldSelector()
          : FieldSelector.fromJson(
              json['fieldSelector'] as Map<String, dynamic>),
      documentId:
          DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
      documentSchema: json['documentSchema'] as String,
      queryName: json['queryName'] as String?,
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PGetDocumentToJson(PGetDocument instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'queryName': instance.queryName,
      'documentId': instance.documentId.toJson(),
      'documentSchema': instance.documentSchema,
      'fieldSelector': instance.fieldSelector.toJson(),
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) => PGetStream(
      queryName: json['queryName'] as String?,
      propertyReferences: (json['propertyReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documentId:
          DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PGetStreamToJson(PGetStream instance) =>
    <String, dynamic>{
      'propertyReferences': instance.propertyReferences,
      'queryName': instance.queryName,
      'documentId': instance.documentId.toJson(),
    };
