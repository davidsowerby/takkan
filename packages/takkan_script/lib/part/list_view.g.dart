// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListView _$ListViewFromJson(Map<String, dynamic> json) => ListView(
      titleProperty: json['titleProperty'] as String? ?? 'title',
      subtitleProperty: json['subtitleProperty'] as String? ?? 'subtitle',
      readOnly: json['readOnly'] as bool? ?? false,
      height: (json['height'] as num?)?.toDouble(),
      caption: json['caption'] as String?,
      help: json['help'] == null
          ? null
          : Help.fromJson(json['help'] as Map<String, dynamic>),
      staticData: json['staticData'] as String?,
      property: json['property'] as String?,
      traitName: json['traitName'] as String? ?? 'ListView',
      tooltip: json['tooltip'] as String?,
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    );

Map<String, dynamic> _$ListViewToJson(ListView instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'height': instance.height,
      'traitName': instance.traitName,
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
