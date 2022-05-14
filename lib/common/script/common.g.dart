// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Common _$CommonFromJson(Map<String, dynamic> json) => Common(
      controlEdit:
          $enumDecodeNullable(_$ControlEditEnumMap, json['controlEdit']) ??
              ControlEdit.inherited,
    );

Map<String, dynamic> _$CommonToJson(Common instance) => <String, dynamic>{
      'controlEdit': _$ControlEditEnumMap[instance.controlEdit],
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
