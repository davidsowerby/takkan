// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PScript _$PScriptFromJson(Map<String, dynamic> json) {
  return PScript(
    conversionErrorMessages: ConversionErrorMessages.fromJson(
        json['conversionErrorMessages'] as Map<String, dynamic>),
    routes: (json['routes'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, PRoute.fromJson(e as Map<String, dynamic>)),
    ),
    name: json['name'] as String,
    query: PQueryConverter.fromJson(json['query'] as Map<String, dynamic>),
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        PTextTrait.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PScriptToJson(PScript instance) {
  final val = <String, dynamic>{
    'version': instance.version,
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'panelStyle': instance.panelStyle.toJson(),
    'writingStyle': instance.writingStyle.toJson(),
    'name': instance.name,
    'routes': instance.routes.map((k, e) => MapEntry(k, e.toJson())),
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

PRoute _$PRouteFromJson(Map<String, dynamic> json) {
  return PRoute(
    page: json['page'] == null
        ? null
        : PPage.fromJson(json['page'] as Map<String, dynamic>),
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        PTextTrait.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PRouteToJson(PRoute instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'writingStyle': instance.writingStyle.toJson(),
      'page': instance.page?.toJson(),
    };

PPage _$PPageFromJson(Map<String, dynamic> json) {
  return PPage(
    pageType: json['pageType'] as String,
    scrollable: json['scrollable'] as bool,
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        PTextTrait.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
    property: json['property'] as String,
    title: json['title'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPageToJson(PPage instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'writingStyle': instance.writingStyle.toJson(),
      'property': instance.property,
      'pageType': instance.pageType,
      'scrollable': instance.scrollable,
      'content': PElementListConverter.toJson(instance.content),
      'title': instance.title,
    };

PPanel _$PPanelFromJson(Map<String, dynamic> json) {
  return PPanel(
    openExpanded: json['openExpanded'] as bool,
    property: json['property'] as String,
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    pageArguments: json['pageArguments'] as Map<String, dynamic>,
    heading: json['heading'] == null
        ? null
        : PPanelHeading.fromJson(json['heading'] as Map<String, dynamic>),
    caption: json['caption'] as String,
    scrollable: json['scrollable'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PPanelStyle.fromJson(json['style'] as Map<String, dynamic>),
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        PTextTrait.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPanelToJson(PPanel instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'writingStyle': instance.writingStyle.toJson(),
      'caption': instance.caption,
      'content': PElementListConverter.toJson(instance.content),
      'openExpanded': instance.openExpanded,
      'scrollable': instance.scrollable,
      'help': instance.help?.toJson(),
      'property': instance.property,
      'style': instance.style?.toJson(),
      'pageArguments': instance.pageArguments,
      'heading': instance.heading?.toJson(),
    };

PPanelHeading _$PPanelHeadingFromJson(Map<String, dynamic> json) {
  return PPanelHeading(
    expandable: json['expandable'] as bool,
    canEdit: json['canEdit'] as bool,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    style: json['style'] == null
        ? null
        : PHeadingStyle.fromJson(json['style'] as Map<String, dynamic>),
    id: json['id'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PPanelHeadingToJson(PPanelHeading instance) =>
    <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'expandable': instance.expandable,
      'canEdit': instance.canEdit,
      'help': instance.help?.toJson(),
      'style': instance.style?.toJson(),
    };

PCommon _$PCommonFromJson(Map<String, dynamic> json) {
  return PCommon(
    panelStyle:
        PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
    writingStyle:
        PTextTrait.fromJson(json['writingStyle'] as Map<String, dynamic>),
    controlEdit: _$enumDecode(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PCommonToJson(PCommon instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'panelStyle': instance.panelStyle.toJson(),
      'writingStyle': instance.writingStyle.toJson(),
    };
