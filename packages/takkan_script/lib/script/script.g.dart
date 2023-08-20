// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Script _$ScriptFromJson(Map<String, dynamic> json) => Script(
      conversionErrorMessages: json['conversionErrorMessages'] == null
          ? const ConversionErrorMessages(patterns: defaultConversionPatterns)
          : ConversionErrorMessages.fromJson(
              json['conversionErrorMessages'] as Map<String, dynamic>),
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => Page.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      name: json['name'] as String,
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
      locale: json['locale'] as String? ?? 'en_GB',
      schema: Schema.fromJson(json['schema'] as Map<String, dynamic>),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.firstLevelPanels,
    )..nameLocale = json['nameLocale'] as String?;

Map<String, dynamic> _$ScriptToJson(Script instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit]!,
      'name': instance.name,
      'locale': instance.locale,
      'version': instance.version.toJson(),
      'nameLocale': instance.nameLocale,
      'schema': instance.schema.toJson(),
      'pages': instance.pages.map((e) => e.toJson()).toList(),
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
