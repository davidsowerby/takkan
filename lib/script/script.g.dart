// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PScript _$PScriptFromJson(Map<String, dynamic> json) => PScript(
      conversionErrorMessages: json['conversionErrorMessages'] == null
          ? const ConversionErrorMessages(patterns: defaultConversionPatterns)
          : ConversionErrorMessages.fromJson(
              json['conversionErrorMessages'] as Map<String, dynamic>),
      pages: json['pages'] == null
          ? const []
          : PPagesJsonConverter.fromJson(json['pages'] as List?),
      name: json['name'] as String,
      version: PVersion.fromJson(json['version'] as Map<String, dynamic>),
      locale: json['locale'] as String? ?? 'en_GB',
      schema: PSchema.fromJson(json['schema'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.firstLevelPanels,
    )..nameLocale = json['nameLocale'] as String?;

Map<String, dynamic> _$PScriptToJson(PScript instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'name': instance.name,
      'locale': instance.locale,
      'version': instance.version.toJson(),
      'nameLocale': instance.nameLocale,
      'schema': instance.schema.toJson(),
      'pages': PPagesJsonConverter.toJson(instance.pages),
      'conversionErrorMessages': instance.conversionErrorMessages.toJson(),
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
