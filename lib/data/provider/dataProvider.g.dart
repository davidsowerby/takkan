// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    providerName: json['providerName'] as String,
    useAuthenticator: json['useAuthenticator'] as bool,
    graphQLDelegate: json['graphQLDelegate'] == null
        ? null
        : PGraphQL.fromJson(json['graphQLDelegate'] as Map<String, dynamic>),
    restDelegate: json['restDelegate'] == null
        ? null
        : PRest.fromJson(json['restDelegate'] as Map<String, dynamic>),
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
    sessionTokenKey: json['sessionTokenKey'] as String,
    configSource:
    PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    signInOptions:
    PSignInOptions.fromJson(json['signInOptions'] as Map<String, dynamic>),
    schemaSource: json['schemaSource'] == null
        ? null
        : PSchemaSource.fromJson(json['schemaSource'] as Map<String, dynamic>),
    signIn: PSignIn.fromJson(json['signIn'] as Map<String, dynamic>),
  )..version = json['version'] as int;
}

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
