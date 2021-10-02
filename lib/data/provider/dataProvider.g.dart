// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) =>
    PDataProvider(
      providerName: json['providerName'] as String,
      useAuthenticator: json['useAuthenticator'] as bool? ?? false,
      graphQLDelegate: json['graphQLDelegate'] == null
          ? null
          : PGraphQL.fromJson(json['graphQLDelegate'] as Map<String, dynamic>),
      restDelegate: json['restDelegate'] == null
          ? null
          : PRest.fromJson(json['restDelegate'] as Map<String, dynamic>),
      headerKeys: (json['headerKeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sessionTokenKey: json['sessionTokenKey'] as String,
      configSource:
          PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
      signInOptions: json['signInOptions'] == null
          ? const PSignInOptions()
          : PSignInOptions.fromJson(
              json['signInOptions'] as Map<String, dynamic>),
      schemaSource: json['schemaSource'] == null
          ? null
          : PSchemaSource.fromJson(
              json['schemaSource'] as Map<String, dynamic>),
      signIn: json['signIn'] == null
          ? const PSignIn()
          : PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
    )..version = json['version'] as int;

Map<String, dynamic> _$PDataProviderToJson(PDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
      'signInOptions': instance.signInOptions.toJson(),
      'signIn': instance.signIn.toJson(),
      'configSource': instance.configSource.toJson(),
      'providerName': instance.providerName,
      'schemaSource': instance.schemaSource?.toJson(),
      'sessionTokenKey': instance.sessionTokenKey,
      'headerKeys': instance.headerKeys,
      'graphQLDelegate': instance.graphQLDelegate?.toJson(),
      'restDelegate': instance.restDelegate?.toJson(),
      'useAuthenticator': instance.useAuthenticator,
    };

PConfigSource _$PConfigSourceFromJson(Map<String, dynamic> json) =>
    PConfigSource(
      segment: json['segment'] as String,
      instance: json['instance'] as String,
    );

Map<String, dynamic> _$PConfigSourceToJson(PConfigSource instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'instance': instance.instance,
    };

PNoDataProvider _$PNoDataProviderFromJson(Map<String, dynamic> json) =>
    PNoDataProvider()..version = json['version'] as int;

Map<String, dynamic> _$PNoDataProviderToJson(PNoDataProvider instance) =>
    <String, dynamic>{
      'version': instance.version,
    };
