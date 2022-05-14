// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) => Page(
      tag: json['tag'] as String?,
      caption: json['caption'] as String?,
      listEntryConfig: json['listEntryConfig'] == null
          ? null
          : Panel.fromJson(json['listEntryConfig'] as Map<String, dynamic>),
      pageType: json['pageType'] as String? ?? 'defaultPage',
      scrollable: json['scrollable'] as bool? ?? true,
      layout: json['layout'] == null
          ? const LayoutDistributedColumn()
          : LayoutJsonConverter.fromJson(
              json['layout'] as Map<String, dynamic>),
      children: json['children'] == null
          ? const []
          : ContentConverter.fromJson(json['children'] as List),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      property: json['property'] as String?,
      dataSelectors: json['dataSelectors'] == null
          ? const [const Property()]
          : DataListJsonConverter.fromJson(json['dataSelectors'] as List?),
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'listEntryConfig': instance.listEntryConfig?.toJson(),
      'children': ContentConverter.toJson(instance.children),
      'pageType': instance.pageType,
      'scrollable': instance.scrollable,
      'tag': instance.tag,
      'dataSelectors': DataListJsonConverter.toJson(instance.dataSelectors),
      'layout': LayoutJsonConverter.toJson(instance.layout),
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
