// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphqlDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PGraphQLDataProvider _$PGraphQLDataProviderFromJson(Map<String, dynamic> json) {
  return PGraphQLDataProvider(
    configSource:
        PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    signInOptions:
        PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    signIn: PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    sessionTokenKey: json['sessionTokenKey'] as String,
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
    graphqlEndpoint: json['graphqlEndpoint'] as String,
    documentEndpoint: json['documentEndpoint'] as String,
    id: json['id'] as String?,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PGraphQLDataProviderToJson(
        PGraphQLDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'sessionTokenKey': instance.sessionTokenKey,
      'headerKeys': instance.headerKeys,
      'documentEndpoint': instance.documentEndpoint,
      'graphqlEndpoint': instance.graphqlEndpoint,
    };
