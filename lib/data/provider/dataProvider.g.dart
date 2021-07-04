// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDataProvider _$PDataProviderFromJson(Map<String, dynamic> json) {
  return PDataProvider(
    headerKeys:
        (json['headerKeys'] as List<dynamic>).map((e) => e as String).toList(),
    documentEndpoint: json['documentEndpoint'] as String,
    sessionTokenKey: json['sessionTokenKey'] as String,
    configSource:
        PConfigSource.fromJson(json['configSource'] as Map<String, dynamic>),
    useGraphQLDelegate: json['useGraphQLDelegate'] as bool,
    useRestDelegate: json['useRestDelegate'] as bool,
    defaultDelegate:
        _$enumDecode(_$CloudInterfaceEnumMap, json['defaultDelegate']),
    authenticatorDelegate:
        _$enumDecode(_$CloudInterfaceEnumMap, json['authenticatorDelegate']),
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
      'configSource': instance.configSource.toJson(),
      'schemaSource': instance.schemaSource?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'sessionTokenKey': instance.sessionTokenKey,
      'headerKeys': instance.headerKeys,
      'documentEndpoint': instance.documentEndpoint,
      'defaultDelegate': _$CloudInterfaceEnumMap[instance.defaultDelegate],
      'authenticatorDelegate':
          _$CloudInterfaceEnumMap[instance.authenticatorDelegate],
      'useGraphQLDelegate': instance.useGraphQLDelegate,
      'useRestDelegate': instance.useRestDelegate,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$CloudInterfaceEnumMap = {
  CloudInterface.rest: 'rest',
  CloudInterface.graphQL: 'graphQL',
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
