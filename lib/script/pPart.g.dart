// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pPart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPart _$PPartFromJson(Map<String, dynamic> json) {
  return PPart(
    caption: json['caption'] as String,
    readOnly: json['readOnly'] as bool,
    particleHeight: (json['particleHeight'] as num)?.toDouble(),
    property: json['property'] as String,
    read: PReadParticleConverter.fromJson(json['read'] as Map<String, dynamic>),
    edit: PEditParticleConverter.fromJson(json['edit'] as Map<String, dynamic>),
    staticData: json['staticData'] as String,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
    tooltip: json['tooltip'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPartToJson(PPart instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'writingStyle': instance.writingStyle.toJson(),
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
