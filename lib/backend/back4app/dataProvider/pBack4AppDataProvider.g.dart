// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pBack4AppDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(
    Map<String, dynamic> json) {
  return PBack4AppDataProvider(
    debug: json['debug'] as bool,
    configSource: json['configSource'] == null
        ? null
        : PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    id: json['id'] as String?,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PBack4AppDataProviderToJson(
        PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'configSource': instance.configSource?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'debug': instance.debug,
    };
