// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    signInOptions:
        PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String?,
    configSource: json['configSource'] == null
        ? null
        : PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'signInOptions': instance.signInOptions.toJson(),
      'configSource': instance.configSource?.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
    };

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    configSource: json['configSource'] == null
        ? null
        : PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    signInOptions:
        PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    signIn: PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    id: json['id'] as String?,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PDataProviderToJson(PDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource?.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
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
