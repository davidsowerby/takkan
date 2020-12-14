// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pPart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPart<T> _$PPartFromJson<T>(Map<String, dynamic> json) {
  return PPart<T>(
    caption: json['caption'] as String,
    readOnly: json['readOnly'] as bool,
    property: json['property'] as String,
    isStatic: _$enumDecodeNullable(_$TripleEnumMap, json['isStatic']),
    staticData: json['staticData'] as String,
    help: json['help'] == null
        ? null
        : PHelp.fromJson(json['help'] as Map<String, dynamic>),
    backend: json['backend'] == null
        ? null
        : PBackend.fromJson(json['backend'] as Map<String, dynamic>),
    dataSource: json['dataSource'] == null
        ? null
        : PDataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
    controlEdit:
        _$enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']),
    id: json['id'] as String,
    tooltip: json['tooltip'] as String,
  );
}

Map<String, dynamic> _$PPartToJson<T>(PPart<T> instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
    'isStatic': _$TripleEnumMap[instance.isStatic],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backend', instance.backend?.toJson());
  writeNotNull('dataSource', instance.dataSource?.toJson());
  val['caption'] = instance.caption;
  val['readOnly'] = instance.readOnly;
  val['property'] = instance.property;
  val['staticData'] = instance.staticData;
  val['help'] = instance.help?.toJson();
  val['tooltip'] = instance.tooltip;
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

const _$TripleEnumMap = {
  Triple.yes: 'yes',
  Triple.no: 'no',
  Triple.inherited: 'inherited',
};

const _$ControlEditEnumMap = {
  ControlEdit.notSetAtThisLevel: 'notSetAtThisLevel',
  ControlEdit.thisOnly: 'thisOnly',
  ControlEdit.thisAndBelow: 'thisAndBelow',
  ControlEdit.pagesOnly: 'pagesOnly',
  ControlEdit.panelsOnly: 'panelsOnly',
  ControlEdit.partsOnly: 'partsOnly',
  ControlEdit.firstLevelPanels: 'firstLevelPanels',
  ControlEdit.noEdit: 'noEdit',
};
