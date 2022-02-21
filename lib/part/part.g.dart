// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPart _$PPartFromJson(Map<String, dynamic> json) => PPart(
      caption: json['caption'] as String?,
      readOnly: json['readOnly'] as bool? ?? false,
      height: (json['height'] as num?)?.toDouble(),
      property: json['property'] as String? ?? notSet,
      readTraitName: json['readTraitName'] as String? ?? '?',
      editTraitName: json['editTraitName'] as String? ?? '?',
      staticData: json['staticData'] as String? ?? notSet,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      tooltip: json['tooltip'] as String?,
    );

Map<String, dynamic> _$PPartToJson(PPart instance) => <String, dynamic>{
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
