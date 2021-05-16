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
    table: json['table'] as String,
    script: json['script'] as String,
    name: json['name'] as String,
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGQueryToJson(PGQuery instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'name': instance.name,
      'script': instance.script,
      'table': instance.table,
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
    table: json['table'] as String,
    name: json['name'] as String,
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
      'name': instance.name,
      'fields': instance.fields,
      'table': instance.table,
      'types': instance.types,
    };

PGet _$PGetFromJson(Map<String, dynamic> json) {
  return PGet(
    documentId: DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences: (json['propertyReferences'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetToJson(PGet instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'documentId': instance.documentId.toJson(),
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) {
  return PGetStream(
    name: json['name'] as String,
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
      'name': instance.name,
      'documentId': instance.documentId.toJson(),
    };
