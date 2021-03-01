// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataProvider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestDataProvider _$PRestDataProviderFromJson(Map<String, dynamic> json) {
  return PRestDataProvider(
    schema: json['schema'] == null
        ? null
        : PSchema.fromJson(json['schema'] as Map<String, dynamic>),
    instanceName: json['instanceName'] as String,
    configFilePath: json['configFilePath'] as String,
    baseUrl: json['baseUrl'] as String,
    checkHealthOnConnect: json['checkHealthOnConnect'] as bool,
    id: json['id'] as String,
    env: _$enumDecodeNullable(_$EnvEnumMap, json['env']),
  );
}

Map<String, dynamic> _$PRestDataProviderToJson(PRestDataProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instanceName': instance.instanceName,
      'schema': instance.schema?.toJson(),
      'env': _$EnvEnumMap[instance.env],
      'configFilePath': instance.configFilePath,
      'baseUrl': instance.baseUrl,
      'checkHealthOnConnect': instance.checkHealthOnConnect,
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
