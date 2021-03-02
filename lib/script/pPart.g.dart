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
    isStatic: _$enumDecodeNullable(_$IsStaticEnumMap, json['isStatic']),
    staticData: json['staticData'] as String,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    panelStyle: json['panelStyle'] == null
        ? null
        : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle: json['writingStyle'] == null
        ? null
        : WritingStyle.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
    tooltip: json['tooltip'] as String,
  );
}

Map<String, dynamic> _$PPartToJson(PPart instance) => <String, dynamic>{
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'isStatic': _$IsStaticEnumMap[instance.isStatic],
      'panelStyle': instance.panelStyle?.toJson(),
      'writingStyle': instance.writingStyle?.toJson(),
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$IsStaticEnumMap = {
  IsStatic.yes: 'yes',
  IsStatic.no: 'no',
  IsStatic.inherited: 'inherited',
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
