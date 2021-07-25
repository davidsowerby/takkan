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
    authenticatorDelegate:
        _$enumDecode(_$CloudInterfaceEnumMap, json['authenticatorDelegate']),
    scriptDelegate:
        _$enumDecode(_$CloudInterfaceEnumMap, json['scriptDelegate']),
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
      'authenticatorDelegate':
          _$CloudInterfaceEnumMap[instance.authenticatorDelegate],
      'scriptDelegate': _$CloudInterfaceEnumMap[instance.scriptDelegate],
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
