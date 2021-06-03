// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    signInOptions: PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String?,
    configSource: PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    signIn: PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    sessionTokenKey: json['sessionTokenKey'] as String,
    headerKeys: (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'sessionTokenKey': instance.sessionTokenKey,
      'headerKeys': instance.headerKeys,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
    };
