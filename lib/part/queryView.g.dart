// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queryView.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PQueryView _$PQueryViewFromJson(Map<String, dynamic> json) {
  return PQueryView(
    titleProperty: json['titleProperty'] as String,
    subtitleProperty: json['subtitleProperty'] as String,
    itemType: _$enumDecode(_$PListViewItemTypeEnumMap, json['itemType']),
    height: (json['height'] as num?)?.toDouble(),
    tooltip: json['tooltip'] as String?,
    caption: json['caption'] as String?,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    pid: json['pid'] as String?,
    readOnly: json['readOnly'] as bool,
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    readTraitName: json['readTraitName'] as String,
    editTraitName: json['editTraitName'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PQueryViewToJson(PQueryView instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pid': instance.pid,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'readOnly': instance.readOnly,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
      'titleProperty': instance.titleProperty,
      'subtitleProperty': instance.subtitleProperty,
      'itemType': _$PListViewItemTypeEnumMap[instance.itemType],
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

const _$PListViewItemTypeEnumMap = {
  PListViewItemType.tile: 'tile',
  PListViewItemType.navTile: 'navTile',
  PListViewItemType.panel: 'panel',
};

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
