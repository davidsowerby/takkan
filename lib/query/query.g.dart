// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGQuery _$PGQueryFromJson(Map<String, dynamic> json) {
  return PGQuery(
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences:
        (json['propertyReferences'] as List)?.map((e) => e as String)?.toList(),
    table: json['table'] as String,
    script: json['script'] as String,
    returnType:
        _$enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGQueryToJson(PGQuery instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'script': instance.script,
      'table': instance.table,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
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
    types: (json['types'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    table: json['table'] as String,
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences:
        (json['propertyReferences'] as List)?.map((e) => e as String)?.toList(),
    returnType:
        _$enumDecodeNullable(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPQueryToJson(PPQuery instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'fields': instance.fields,
      'table': instance.table,
      'types': instance.types,
    };

PGet _$PGetFromJson(Map<String, dynamic> json) {
  return PGet(
    documentId: json['documentId'] == null
        ? null
        : DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
    variables: json['variables'] as Map<String, dynamic>,
    propertyReferences:
        (json['propertyReferences'] as List)?.map((e) => e as String)?.toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetToJson(PGet instance) => <String, dynamic>{
      'version': instance.version,
      'variables': instance.variables,
      'propertyReferences': instance.propertyReferences,
      'documentId': instance.documentId?.toJson(),
    };

PGetStream _$PGetStreamFromJson(Map<String, dynamic> json) {
  return PGetStream(
    propertyReferences:
        (json['propertyReferences'] as List)?.map((e) => e as String)?.toList(),
    documentId: json['documentId'] == null
        ? null
        : DocumentId.fromJson(json['documentId'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGetStreamToJson(PGetStream instance) =>
    <String, dynamic>{
      'version': instance.version,
      'propertyReferences': instance.propertyReferences,
      'documentId': instance.documentId?.toJson(),
    };
