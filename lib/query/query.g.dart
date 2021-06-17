// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGQuery _$PGQueryFromJson(Map<String, dynamic> json) {
  return PGQuery(
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    script: json['script'] as String,
    querySchema: json['querySchema'] as String,
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGQueryToJson(PGQuery instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'querySchema': instance.querySchema,
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
  QueryReturnType.futureSingle: 'futureSingle',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamSingle: 'streamSingle',
  QueryReturnType.streamList: 'streamList',
};

PPQuery _$PPQueryFromJson(Map<String, dynamic> json) {
  return PPQuery(
    fields: json['fields'] as String,
    types: Map<String, String>.from(json['types'] as Map),
    querySchema: json['querySchema'] as String,
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
      'querySchema': instance.querySchema,
      'fields': instance.fields,
      'types': instance.types,
    };

PGetDocument _$PGetDocumentFromJson(Map<String, dynamic> json) {
  return PGetDocument(
    documentId: DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    documentSchema: json['documentSchema'] as String,
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences:
        (json['propertyReferences'] as List<dynamic>).map((e) => e as String).toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetDocumentToJson(PGetDocument instance) =>
    <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'documentId': instance.documentId.toJson(),
      'documentSchema': instance.documentSchema,
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) {
  return PGetStream(
    querySchema: json['querySchema'] as String,
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
      'querySchema': instance.querySchema,
      'documentId': instance.documentId.toJson(),
    };
