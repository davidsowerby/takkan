// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PCommon _$PCommonFromJson(Map<String, dynamic> json) {
  return PCommon(
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String?,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PCommonToJson(PCommon instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
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

const _$ControlEditEnumMap = {
  ControlEdit.inherited: 'inherited',
  ControlEdit.thisOnly: 'thisOnly',
  ControlEdit.thisAndBelow: 'thisAndBelow',
  ControlEdit.pagesOnly: 'pagesOnly',
  ControlEdit.panelsOnly: 'panelsOnly',
  ControlEdit.partsOnly: 'partsOnly',
  ControlEdit.firstLevelPanels: 'firstLevelPanels',
  ControlEdit.noEdit: 'noEdit',
};
