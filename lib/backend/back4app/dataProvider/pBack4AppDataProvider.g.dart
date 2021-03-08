// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pBack4AppDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(
    Map<String, dynamic> json) {
  return PBack4AppDataProvider(
    debug: json['debug'] as bool,
    appId: json['appId'] as String,
    clientId: json['clientId'] as String,
    baseUrl: json['baseUrl'] as String,
    id: json['id'] as String,
    schema: json['schema'] == null
        ? null
        : PSchema.fromJson(json['schema'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
  );
}

Map<String, dynamic> _$PBack4AppDataProviderToJson(
        PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schema': instance.schema?.toJson(),
      'baseUrl': instance.baseUrl,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'debug': instance.debug,
      'appId': instance.appId,
      'clientId': instance.clientId,
    };
