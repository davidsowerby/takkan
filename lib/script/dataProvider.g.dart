// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    baseUrl: json['baseUrl'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String,
    headers: (json['headers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'schemaSource': instance.schemaSource?.toJson(),
      'baseUrl': instance.baseUrl,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headers': instance.headers,
    };

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    id: json['id'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PDataProviderToJson(PDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'schemaSource': instance.schemaSource?.toJson(),
    };
