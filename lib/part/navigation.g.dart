// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PNavPart _$PNavPartFromJson(Map<String, dynamic> json) {
  return PNavPart(
    readOnly: json['readOnly'] as bool,
    caption: json['caption'] as String,
    property: json['property'] as String,
    staticData: json['staticData'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PNavPartToJson(PNavPart instance) => <String, dynamic>{
      'version': instance.version,
      'caption': instance.caption,
      'readOnly': instance.readOnly,
      'property': instance.property,
      'staticData': instance.staticData,
    };

PNavButtonSet _$PNavButtonSetFromJson(Map<String, dynamic> json) {
  return PNavButtonSet()..version = json['version'] as int;
}

Map<String, dynamic> _$PNavButtonSetToJson(PNavButtonSet instance) =>
    <String, dynamic>{
      'version': instance.version,
    };
