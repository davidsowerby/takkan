// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    instanceName: json['instanceName'] as String,
    env: _$enumDecodeNullable(_$EnvEnumMap, json['env']),
    connectionData: json['connectionData'] as Map<String, dynamic>,
    parent: json['parent'] == null
        ? null
        : PScript.fromJson(json['parent'] as Map<String, dynamic>),
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    configFilePath: json['configFilePath'] as String,
  );
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'instanceName': instance.instanceName,
      'connectionData': instance.connectionData,
      'parent': instance.parent?.toJson(),
      'checkHealthOnConnect': instance.checkHealthOnConnect,
      'env': _$EnvEnumMap[instance.env],
      'configFilePath': instance.configFilePath,
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

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

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
