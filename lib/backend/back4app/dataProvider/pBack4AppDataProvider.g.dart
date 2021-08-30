// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pBack4AppDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(
    Map<String, dynamic> json) {
  return PBack4AppDataProvider(
    signInOptions:
        PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    signIn: PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    configSource:
        PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    useAuthenticator: json['useAuthenticator'] as bool,
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PBack4AppDataProviderToJson(
        PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'headerKeys': instance.headerKeys,
      'useAuthenticator': instance.useAuthenticator,
    };
