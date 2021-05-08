// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listView.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PListView _$PListViewFromJson(Map<String, dynamic> json) {
  return PListView(
    isQuery: json['isQuery'] as bool,
    titleProperty: json['titleProperty'] as String,
    itemType:
        _$enumDecodeNullable(_$PListViewItemTypeEnumMap, json['itemType']),
    subtitleProperty: json['subtitleProperty'] as String,
    readOnly: json['readOnly'] as bool,
    caption: json['caption'] as String,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    staticData: json['staticData'] as String,
    property: json['property'] as String,
    readTraitName: json['readTraitName'] as String,
    editTraitName: json['editTraitName'] as String,
    tooltip: json['tooltip'] as String,
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PListViewToJson(PListView instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'readOnly': instance.readOnly,
      'property': instance.property,
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
