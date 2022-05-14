// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Text _$TextFromJson(Map<String, dynamic> json) => Text(
      caption: json['caption'] as String?,
      readOnly: json['readOnly'] as bool? ?? false,
      height: (json['height'] as num?)?.toDouble() ?? 60,
      property: json['property'] as String?,
      readTraitName: json['readTraitName'] as String? ?? 'text-read-default',
      editTraitName: json['editTraitName'] as String? ?? 'TextBox-default',
      staticData: json['staticData'] as String?,
      help: json['help'] == null
          ? null
          : Help.fromJson(json['help'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      tooltip: json['tooltip'] as String?,
    );

Map<String, dynamic> _$TextToJson(Text instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
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
