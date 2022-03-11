// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPageStatic _$PPageStaticFromJson(Map<String, dynamic> json) => PPageStatic(
      routes: (json['routes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      caption: json['caption'] as String?,
      pageType: json['pageType'] as String? ?? 'defaultPage',
      scrollable: json['scrollable'] as bool? ?? true,
      layout: json['layout'] == null
          ? const PLayoutDistributedColumn()
          : PLayoutJsonConverter.fromJson(
              json['layout'] as Map<String, dynamic>),
      children: json['children'] == null
          ? const []
          : PContentConverter.fromJson(json['children'] as List),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    );

Map<String, dynamic> _$PPageStaticToJson(PPageStatic instance) =>
    <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'children': PContentConverter.toJson(instance.children),
      'pageType': instance.pageType,
      'scrollable': instance.scrollable,
      'routes': instance.routes,
      'layout': PLayoutJsonConverter.toJson(instance.layout),
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
