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
    serverUrl: json['serverUrl'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String,
    headers: (json['headers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    configSource: json['configSource'] == null
        ? null
        : PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'configSource': instance.configSource?.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'serverUrl': instance.serverUrl,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headers': instance.headers,
    };

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    configSource: json['configSource'] == null
        ? null
        : PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    signInOptions: json['signInOptions'] == null
        ? null
        : PSignInOptions.fromJson(
            json['signInOptions'] as Map<String, dynamic>),
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
      'signInOptions': instance.signInOptions?.toJson(),
      'configSource': instance.configSource?.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
    };

PConfigSource _$PConfigSourceFromJson(Map<String, dynamic> json) {
  return PConfigSource(
    segment: json['segment'] as String,
    instance: json['instance'] as String,
  );
}

Map<String, dynamic> _$PConfigSourceToJson(PConfigSource instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'instance': instance.instance,
    };

PNoDataProvider _$PNoDataProviderFromJson(Map<String, dynamic> json) {
  return PNoDataProvider()..version = json['version'] as int;
}

Map<String, dynamic> _$PNoDataProviderToJson(PNoDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
    };
