// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBackend _$PBackendFromJson(Map<String, dynamic> json) {
  return PBackend(
    instanceName: json['instanceName'] as String,
    schema: json['schema'] == null
        ? null
        : PSchema.fromJson(json['schema'] as Map<String, dynamic>),
    env: _$enumDecodeNullable(_$EnvEnumMap, json['env']),
    id: json['id'] as String,
    signInOptions: json['signInOptions'] == null
        ? null
        : PSignInOptions.fromJson(
            json['signInOptions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBackendToJson(PBackend instance) => <String, dynamic>{
      'id': instance.id,
      'instanceName': instance.instanceName,
      'schema': instance.schema?.toJson(),
      'env': _$EnvEnumMap[instance.env],
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
