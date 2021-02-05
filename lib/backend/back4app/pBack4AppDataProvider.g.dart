// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pBack4AppDataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBack4AppDataProvider _$PBack4AppDataProviderFromJson(Map<String, dynamic> json) {
  return PBack4AppDataProvider(
    debug: json['debug'] as bool,
    appId: json['appId'] as String,
    clientKey: json['clientKey'] as String,
    baseUrl: json['baseUrl'] as String,
    instanceName: json['instanceName'] as String,
    env: _$enumDecodeNullable(_$EnvEnumMap, json['env']),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
  );
}

Map<String, dynamic> _$PBack4AppDataProviderToJson(PBack4AppDataProvider instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'instanceName': instance.instanceName,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'env': _$EnvEnumMap[instance.env],
      'debug': instance.debug,
      'appId': instance.appId,
      'clientKey': instance.clientKey,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries.singleWhere((e) => e.value == source, orElse: () => null)?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EnvEnumMap = {
  Env.dev: 'dev',
  Env.test: 'test',
  Env.qa: 'qa',
  Env.prod: 'prod',
};
