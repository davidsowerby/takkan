// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PText _$PTextFromJson(Map<String, dynamic> json) => PText(
      caption: json['caption'] as String?,
      readOnly: json['readOnly'] as bool? ?? false,
      height: (json['height'] as num).toDouble(),
      property: json['property'] as String? ?? notSet,
      readTraitName:
          json['readTraitName'] as String? ?? 'queryView-read-default',
      editTraitName:
          json['editTraitName'] as String? ?? 'queryView-edit-default',
      staticData: json['staticData'] as String,
      help: json['help'] == null
          ? null
          : PHelp.fromJson(json['help'] as Map<String, dynamic>),
      controlEdit:
          _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.firstLevelPanels,
      pid: json['pid'] as String?,
      tooltip: json['tooltip'] as String?,
    )..version = json['version'] as int;

Map<String, dynamic> _$PTextToJson(PText instance) => <String, dynamic>{
      'version': instance.version,
      'pid': instance.pid,
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'help': instance.help?.toJson(),
      'tooltip': instance.tooltip,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
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
