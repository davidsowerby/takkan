// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PListView _$PListViewFromJson(Map<String, dynamic> json) => PListView(
      isQuery: json['isQuery'] as bool? ?? false,
      titleProperty: json['titleProperty'] as String? ?? 'title',
      subtitleProperty: json['subtitleProperty'] as String? ?? 'subtitle',
      readOnly: json['readOnly'] as bool? ?? false,
      caption: json['caption'] as String?,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      staticData: json['staticData'] as String?,
      property: json['property'] as String,
      readTraitName: json['readTraitName'] as String? ?? 'list-read-default',
      editTraitName: json['editTraitName'] as String? ?? 'list-edit-default',
      tooltip: json['tooltip'] as String?,
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      pid: json['pid'] as String?,
    );

Map<String, dynamic> _$PListViewToJson(PListView instance) => <String, dynamic>{
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
