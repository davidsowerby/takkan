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
      script: json['script'] as String,
      queryName: json['queryName'] as String,
      returnType:
          _$enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']) ??
              QueryReturnType.futureList,
    )..version = json['version'] as int;

Map<String, dynamic> _$PGraphQLQueryToJson(PGraphQLQuery instance) =>
    <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'queryName': instance.queryName,
      'documentSchema': instance.documentSchema,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

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
          _$enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']) ??
              QueryReturnType.futureList,
    )..version = json['version'] as int;

Map<String, dynamic> _$PPQueryToJson(PPQuery instance) => <String, dynamic>{
      'version': instance.version,
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
    )..version = json['version'] as int;

Map<String, dynamic> _$PGetDocumentToJson(PGetDocument instance) =>
    <String, dynamic>{
      'version': instance.version,
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
    )..version = json['version'] as int;

Map<String, dynamic> _$PGetStreamToJson(PGetStream instance) =>
    <String, dynamic>{
      'version': instance.version,
      'propertyReferences': instance.propertyReferences,
      'queryName': instance.queryName,
      'documentId': instance.documentId.toJson(),
    };
