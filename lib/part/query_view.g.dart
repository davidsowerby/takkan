// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryView _$QueryViewFromJson(Map<String, dynamic> json) => QueryView(
      titleProperty: json['titleProperty'] as String? ?? 'title',
      subtitleProperty: json['subtitleProperty'] as String? ?? 'subtitle',
      height: (json['height'] as num?)?.toDouble() ?? 100,
      tooltip: json['tooltip'] as String?,
      caption: json['caption'] as String?,
      help: json['help'] == null
          ? null
          : Help.fromJson(json['help'] as Map<String, dynamic>),
      pid: json['pid'] as String?,
      readOnly: json['readOnly'] as bool? ?? false,
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      readTraitName:
          json['readTraitName'] as String? ?? 'queryView-read-default',
      editTraitName:
          json['editTraitName'] as String? ?? 'queryView-edit-default',
    );

Map<String, dynamic> _$QueryViewToJson(QueryView instance) => <String, dynamic>{
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
