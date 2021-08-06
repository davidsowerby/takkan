// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restQuery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PRestQuery _$PRestQueryFromJson(Map<String, dynamic> json) {
  return PRestQuery(
    paramsAsPath: json['paramsAsPath'] as bool,
    querySchemaName: json['querySchemaName'] as String,
    params: Map<String, String>.from(json['params'] as Map),
    returnType: _$enumDecode(_$QueryReturnTypeEnumMap, json['returnType']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRestQueryToJson(PRestQuery instance) =>
    <String, dynamic>{
      'version': instance.version,
      'returnType': _$QueryReturnTypeEnumMap[instance.returnType],
      'querySchemaName': instance.querySchemaName,
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
  QueryReturnType.futureItem: 'futureItem',
  QueryReturnType.futureList: 'futureList',
  QueryReturnType.streamItem: 'streamItem',
  QueryReturnType.streamList: 'streamList',
  QueryReturnType.futureDocument: 'futureDocument',
  QueryReturnType.streamDocument: 'streamDocument',
};
