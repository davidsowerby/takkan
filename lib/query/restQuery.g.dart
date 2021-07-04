// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restQuery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestQuery _$PRestQueryFromJson(Map<String, dynamic> json) {
  return PRestQuery(
    paramsAsPath: json['paramsAsPath'] as bool,
    querySchema: json['querySchema'] as String,
    params: Map<String, String>.from(json['params'] as Map),
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestQueryToJson(PRestQuery instance) =>
    <String, dynamic>{
      'version': instance.version,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'querySchema': instance.querySchema,
      'paramsAsPath': instance.paramsAsPath,
      'params': instance.params,
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

const _$QueryReturnTypeEnumMap = {
  QueryReturnType.futureSingle: 'futureSingle',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamSingle: 'streamSingle',
  QueryReturnType.streamList: 'streamList',
};
