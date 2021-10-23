// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listView.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PListView _$PListViewFromJson(Map<String, dynamic> json) => PListView(
      isQuery: json['isQuery'] as bool? ?? false,
      titleProperty: json['titleProperty'] as String? ?? 'title',
      itemType:
          _$enumDecodeNullable(_$PListViewItemTypeEnumMap, json['itemType']) ??
              PListViewItemType.tile,
      subtitleProperty: json['subtitleProperty'] as String? ?? 'subtitle',
      readOnly: json['readOnly'] as bool? ?? true,
      caption: json['caption'] as String?,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      staticData: json['staticData'] as String? ?? '',
      property: json['property'] as String? ?? notSet,
      readTraitName: json['readTraitName'] as String? ?? 'PNavButton-default',
      editTraitName: json['editTraitName'] as String? ?? 'PNavButton-default',
      tooltip: json['tooltip'] as String?,
      controlEdit:
          _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      pid: json['pid'] as String?,
    )..version = json['version'] as int;

Map<String, dynamic> _$PListViewToJson(PListView instance) => <String, dynamic>{
      'version': instance.version,
      'pid': instance.pid,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
      'isQuery': instance.isQuery,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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
