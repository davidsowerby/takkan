// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pBack4AppDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(
    Map<String, dynamic> json) {
  return PBack4AppDataProvider(
    debug: json['debug'] as bool,
    serverUrl: json['serverUrl'] as String,
    configSource:
        PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    id: json['id'] as String?,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    signInOptions:
        PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PBack4AppDataProviderToJson(
        PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'signInOptions': instance.signInOptions.toJson(),
      'configSource': instance.configSource.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'debug': instance.debug,
      'serverUrl': instance.serverUrl,
    };
