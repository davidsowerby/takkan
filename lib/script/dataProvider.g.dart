// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    schema: json['schema'] == null
        ? null
        : PSchema.fromJson(json['schema'] as Map<String, dynamic>),
    baseUrl: json['baseUrl'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String,
    headers: (json['headers'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schema': instance.schema?.toJson(),
      'baseUrl': instance.baseUrl,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'headers': instance.headers,
    };

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    schema: json['schema'] == null
        ? null
        : PSchema.fromJson(json['schema'] as Map<String, dynamic>),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PDataProviderToJson(PDataProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schema': instance.schema?.toJson(),
    };
