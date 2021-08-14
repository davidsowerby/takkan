// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQLQuery _$PGraphQLQueryFromJson(Map<String, dynamic> json) {
  return PGraphQLQuery(
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    script: json['script'] as String,
    querySchemaName: json['querySchemaName'] as String,
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGraphQLQueryToJson(PGraphQLQuery instance) =>
    <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'querySchemaName': instance.querySchemaName,
      'script': instance.script,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QueryReturnTypeEnumMap = {
  QueryReturnType.futureItem: 'futureItem',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamItem: 'streamItem',
  QueryReturnType.streamList: 'streamList',
  QueryReturnType.futureDocument: 'futureDocument',
  QueryReturnType.streamDocument: 'streamDocument',
};

PPQuery _$PPQueryFromJson(Map<String, dynamic> json) {
  return PPQuery(
    fields: json['fields'] as String,
    types: Map<String, String>.from(json['types'] as Map),
    querySchemaName: json['querySchemaName'] as String,
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPQueryToJson(PPQuery instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'querySchemaName': instance.querySchemaName,
      'fields': instance.fields,
      'types': instance.types,
    };

PGetDocument _$PGetDocumentFromJson(Map<String, dynamic> json) {
  return PGetDocument(
    fieldSelector:
        FieldSelector.fromJson(json['fieldSelector'] as Map<String, dynamic>),
    documentId: DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    documentSchema: json['documentSchema'] as String,
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetDocumentToJson(PGetDocument instance) =>
    <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'documentId': instance.documentId.toJson(),
      'documentSchema': instance.documentSchema,
      'fieldSelector': instance.fieldSelector.toJson(),
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) {
  return PGetStream(
    querySchemaName: json['querySchemaName'] as String,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    documentId: DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetStreamToJson(PGetStream instance) =>
    <String, dynamic>{
      'version': instance.version,
      'propertyReferences': instance.propertyReferences,
      'querySchemaName': instance.querySchemaName,
      'documentId': instance.documentId.toJson(),
    };
