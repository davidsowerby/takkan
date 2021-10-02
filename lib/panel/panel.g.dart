// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPanel _$PPanelFromJson(Map<String, dynamic> json) => PPanel(
      openExpanded: json['openExpanded'] as bool? ?? true,
      property: json['property'] as String? ?? notSet,
      content: json['content'] == null
          ? const []
          : PElementListConverter.fromJson(json['content'] as List),
      pageArguments: json['pageArguments'] as Map<String, dynamic>? ?? const {},
      layout: json['layout'] == null
          ? const PPanelLayout()
          : PPanelLayout.fromJson(json['layout'] as Map<String, dynamic>),
      heading: json['heading'] == null
          ? null
          : PPanelHeading.fromJson(json['heading'] as Map<String, dynamic>),
      caption: json['caption'] as String?,
      scrollable: json['scrollable'] as bool? ?? false,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      panelStyle: json['panelStyle'] == null
          ? const PPanelStyle()
          : PPanelStyle.fromJson(json['panelStyle'] as Map<String, dynamic>),
      controlEdit:
          _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.firstLevelPanels,
    )..version = json['version'] as int;

Map<String, dynamic> _$PPanelToJson(PPanel instance) => <String, dynamic>{
      'version': instance.version,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'content': PElementListConverter.toJson(instance.content),
      'layout': instance.layout.toJson(),
      'openExpanded': instance.openExpanded,
      'scrollable': instance.scrollable,
      'help': instance.help?.toJson(),
      'panelStyle': instance.panelStyle.toJson(),
      'pageArguments': instance.pageArguments,
      'heading': instance.heading?.toJson(),
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

PPanelHeading _$PPanelHeadingFromJson(Map<String, dynamic> json) =>
    PPanelHeading(
      expandable: json['expandable'] as bool? ?? true,
      canEdit: json['canEdit'] as bool? ?? false,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      style: json['style'] == null
          ? const PHeadingStyle()
          : PHeadingStyle.fromJson(json['style'] as Map<String, dynamic>),
    )..version = json['version'] as int;

Map<String, dynamic> _$PPanelHeadingToJson(PPanelHeading instance) =>
    <String, dynamic>{
      'version': instance.version,
      'expandable': instance.expandable,
      'canEdit': instance.canEdit,
      'help': instance.help?.toJson(),
      'style': instance.style.toJson(),
    };

PPanelLayout _$PPanelLayoutFromJson(Map<String, dynamic> json) => PPanelLayout(
      padding: json['padding'] == null
          ? const PPadding()
          : PPadding.fromJson(json['padding'] as Map<String, dynamic>),
      width: (json['width'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PPanelLayoutToJson(PPanelLayout instance) =>
    <String, dynamic>{
      'padding': instance.padding.toJson(),
      'width': instance.width,
    };
