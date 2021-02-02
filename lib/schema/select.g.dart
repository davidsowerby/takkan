// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSelectBoolean _$PSelectBooleanFromJson(Map<String, dynamic> json) {
  return PSelectBoolean(
    defaultValue:
        (json['defaultValue'] as List)?.map((e) => e as bool)?.toList(),
  );
}

Map<String, dynamic> _$PSelectBooleanToJson(PSelectBoolean instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };

PSelectString _$PSelectStringFromJson(Map<String, dynamic> json) {
  return PSelectString(
    defaultValue:
        (json['defaultValue'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PSelectStringToJson(PSelectString instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue,
    };
