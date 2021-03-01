// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PAuthenticator _$PAuthenticatorFromJson(Map<String, dynamic> json) {
  return PAuthenticator(
    signInOptions: json['signInOptions'] == null
        ? null
        : PSignInOptions.fromJson(
            json['signInOptions'] as Map<String, dynamic>),
    id: json['id'] as String,
    instanceName: json['instanceName'] as String,
    env: _$enumDecodeNullable(_$EnvEnumMap, json['env']),
    configFilePath: json['configFilePath'] as String,
  );
}

Map<String, dynamic> _$PAuthenticatorToJson(PAuthenticator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instanceName': instance.instanceName,
      'env': _$EnvEnumMap[instance.env],
      'configFilePath': instance.configFilePath,
      'signInOptions': instance.signInOptions?.toJson(),
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
