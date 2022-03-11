// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_panel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPanelStatic _$PPanelStaticFromJson(Map<String, dynamic> json) => PPanelStatic(
      caption: json['caption'] as String?,
      openExpanded: json['openExpanded'] as bool? ?? true,
      children: json['children'] == null
          ? const []
          : PContentConverter.fromJson(json['children'] as List),
      pageArguments: json['pageArguments'] as Map<String, dynamic>? ?? const {},
      layout: json['layout'] == null
          ? const PLayoutDistributedColumn()
          : PLayoutJsonConverter.fromJson(
              json['layout'] as Map<String, dynamic>),
      heading: json['heading'] == null
          ? null
          : PPanelHeading.fromJson(json['heading'] as Map<String, dynamic>),
      scrollable: json['scrollable'] as bool? ?? false,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      panelStyle: json['panelStyle'] == null
          ? const PPanelStyle()
          : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    );

Map<String, dynamic> _$PPanelStaticToJson(PPanelStatic instance) =>
    <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'children': PContentConverter.toJson(instance.children),
      'layout': PLayoutJsonConverter.toJson(instance.layout),
      'openExpanded': instance.openExpanded,
      'scrollable': instance.scrollable,
      'help': instance.help?.toJson(),
      'panelStyle': instance.panelStyle.toJson(),
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
