// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PList _$PListFromJson(Map<String, dynamic> json) {
  return PList(
    read: PReadParticleConverter.fromJson(json['read'] as Map<String, dynamic>),
    edit: PEditParticleConverter.fromJson(json['edit'] as Map<String, dynamic>),
    readOnly: json['readOnly'] as bool,
    particleHeight: (json['particleHeight'] as num)?.toDouble(),
    caption: json['caption'] as String,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    staticData: json['staticData'] as String,
    property: json['property'] as String,
    tooltip: json['tooltip'] as String,
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    textTrait: PTextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PListToJson(PList instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'textTrait': instance.textTrait.toJson(),
      'caption': instance.caption,
      'readOnly': instance.readOnly,
      'property': instance.property,
      'staticData': instance.staticData,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'particleHeight': instance.particleHeight,
      'read': PReadParticleConverter.toJson(instance.read),
      'edit': PEditParticleConverter.toJson(instance.edit),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

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
