// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_panel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelStatic _$PanelStaticFromJson(Map<String, dynamic> json) => PanelStatic(
      caption: json['caption'] as String?,
      openExpanded: json['openExpanded'] as bool? ?? true,
      children: json['children'] == null
          ? const []
          : ContentConverter.fromJson(json['children'] as List),
      pageArguments: json['pageArguments'] as Map<String, dynamic>? ?? const {},
      layout: json['layout'] == null
          ? const LayoutDistributedColumn()
          : LayoutJsonConverter.fromJson(
              json['layout'] as Map<String, dynamic>),
      heading: json['heading'] == null
          ? null
          : PanelHeading.fromJson(json['heading'] as Map<String, dynamic>),
      scrollable: json['scrollable'] as bool? ?? false,
      help: json['help'] == null
          ? null
          : Help.fromJson(json['help'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    );

Map<String, dynamic> _$PanelStaticToJson(PanelStatic instance) =>
    <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'children': ContentConverter.toJson(instance.children),
      'layout': LayoutJsonConverter.toJson(instance.layout),
      'openExpanded': instance.openExpanded,
      'scrollable': instance.scrollable,
      'help': instance.help?.toJson(),
      'pageArguments': instance.pageArguments,
      'heading': instance.heading?.toJson(),
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
