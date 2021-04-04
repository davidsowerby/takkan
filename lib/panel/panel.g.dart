// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPanel _$PPanelFromJson(Map<String, dynamic> json) {
  return PPanel(
    openExpanded: json['openExpanded'] as bool,
    property: json['property'] as String,
    content: PElementListConverter.fromJson(
        json['content'] as List<Map<String, dynamic>>),
    pageArguments: json['pageArguments'] as Map<String, dynamic>,
    layout: json['layout'] == null
        ? null
        : PPanelLayout.fromJson(json['layout'] as Map<String, dynamic>),
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
      'layout': instance.layout?.toJson(),
      'openExpanded': instance.openExpanded,
      'scrollable': instance.scrollable,
      'help': instance.help?.toJson(),
      'property': instance.property,
      'style': instance.style?.toJson(),
      'pageArguments': instance.pageArguments,
      'heading': instance.heading?.toJson(),
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

PListTile _$PListTileFromJson(Map<String, dynamic> json) {
  return PListTile()..version = json['version'] as int;
}

Map<String, dynamic> _$PListTileToJson(PListTile instance) => <String, dynamic>{
      'version': instance.version,
    };

PNavTile _$PNavTileFromJson(Map<String, dynamic> json) {
  return PNavTile()..version = json['version'] as int;
}

Map<String, dynamic> _$PNavTileToJson(PNavTile instance) => <String, dynamic>{
      'version': instance.version,
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

PPanelLayout _$PPanelLayoutFromJson(Map<String, dynamic> json) {
  return PPanelLayout(
    padding: json['padding'] == null
        ? null
        : PPadding.fromJson(json['padding'] as Map<String, dynamic>),
    width: (json['width'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PPanelLayoutToJson(PPanelLayout instance) =>
    <String, dynamic>{
      'padding': instance.padding?.toJson(),
      'width': instance.width,
    };
