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
      locale: json['locale'] as String? ?? 'en_GB',
      controlEdit:
          _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    )
      ..version = json['version'] as int
      ..nameLocale = json['nameLocale'] as String?;

Map<String, dynamic> _$PScriptToJson(PScript instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'name': instance.name,
      'locale': instance.locale,
      'nameLocale': instance.nameLocale,
      'routes': instance.routes.map((k, e) => MapEntry(k, e.toJson())),
      'conversionErrorMessages': instance.conversionErrorMessages.toJson(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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
          _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
      property: json['property'] as String? ?? notSet,
      title: json['title'] as String,
    )..version = json['version'] as int;

Map<String, dynamic> _$PPageToJson(PPage instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'property': instance.property,
      'pageType': instance.pageType,
      'scrollable': instance.scrollable,
      'content': PElementListConverter.toJson(instance.content),
      'layout': instance.layout.toJson(),
      'title': instance.title,
    };
