// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PScript _$PScriptFromJson(Map<String, dynamic> json) {
  return PScript(
    conversionErrorMessages: ConversionErrorMessages.fromJson(
        json['conversionErrorMessages'] as Map<String, dynamic>),
    pages: (json['pages'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PPage.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
    locale: json['locale'] as String,
    query: PQueryConverter.fromJson(json['query'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
  )
    ..version = json['version'] as int
    ..nameLocale = json['nameLocale'] as String?;
}

Map<String, dynamic> _$PScriptToJson(PScript instance) {
  final val = <String, dynamic>{
    'version': instance.version,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'name': instance.name,
    'locale': instance.locale,
    'nameLocale': instance.nameLocale,
    'pages': instance.pages.map((k, e) => MapEntry(k, e.toJson())),
    'conversionErrorMessages': instance.conversionErrorMessages.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('query', PQueryConverter.toJson(instance.query));
  return val;
}

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

PPage _$PPageFromJson(Map<String, dynamic> json) {
  return PPage(
    pageType: json['pageType'] as String,
    scrollable: json['scrollable'] as bool,
    layout: PPageLayout.fromJson(json['layout'] as Map<String, dynamic>),
    content: PElementListConverter.fromJson(json['content'] as List),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    property: json['property'] as String,
    title: json['title'] as String,
  )..version = json['version'] as int;
}

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
