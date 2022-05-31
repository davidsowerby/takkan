// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Panel _$PanelFromJson(Map<String, dynamic> json) => Panel(
      caption: json['caption'] as String?,
      dataSelectors: json['dataSelectors'] == null
          ? const [Property()]
          : DataListJsonConverter.fromJson(json['dataSelectors'] as List?),
      listEntryConfig: json['listEntryConfig'] == null
          ? null
          : Panel.fromJson(json['listEntryConfig'] as Map<String, dynamic>),
      openExpanded: json['openExpanded'] as bool? ?? true,
      property: json['property'] as String?,
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

Map<String, dynamic> _$PanelToJson(Panel instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'listEntryConfig': instance.listEntryConfig?.toJson(),
      'children': ContentConverter.toJson(instance.children),
      'layout': LayoutJsonConverter.toJson(instance.layout),
      'dataSelectors': DataListJsonConverter.toJson(instance.dataSelectors),
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

PanelHeading _$PanelHeadingFromJson(Map<String, dynamic> json) => PanelHeading(
      expandable: json['expandable'] as bool? ?? true,
      canEdit: json['canEdit'] as bool? ?? false,
      help: json['help'] == null
          ? null
          : Help.fromJson(json['help'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PanelHeadingToJson(PanelHeading instance) =>
    <String, dynamic>{
      'expandable': instance.expandable,
      'canEdit': instance.canEdit,
      'help': instance.help?.toJson(),
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      children: ContentConverter.fromJson(json['children'] as List),
    )..caption = json['caption'] as String?;

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'caption': instance.caption,
      'children': ContentConverter.toJson(instance.children),
    };
