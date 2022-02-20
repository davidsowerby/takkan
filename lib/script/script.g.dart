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
      routes: (json['routes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, PPage.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
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
      'routes': instance.routes.map((k, e) => MapEntry(k, e.toJson())),
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

PPage _$PPageFromJson(Map<String, dynamic> json) => PPage(
      pageType: json['pageType'] as String? ?? 'defaultPage',
      scrollable: json['scrollable'] as bool? ?? true,
      layout: json['layout'] == null
          ? const PPageLayout()
          : PPageLayout.fromJson(json['layout'] as Map<String, dynamic>),
      content: json['content'] == null
          ? const []
          : PElementListConverter.fromJson(json['content'] as List),
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      property: json['property'] as String? ?? notSet,
      title: json['title'] as String,
    );

Map<String, dynamic> _$PPageToJson(PPage instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'property': instance.property,
      'pageType': instance.pageType,
      'scrollable': instance.scrollable,
      'content': PElementListConverter.toJson(instance.content),
      'layout': instance.layout.toJson(),
      'title': instance.title,
    };
