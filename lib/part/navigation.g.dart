// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PNavButton _$PNavButtonFromJson(Map<String, dynamic> json) {
  return PNavButton(
    readOnly: json['readOnly'] as bool,
    route: json['route'] as String,
    caption: json['caption'] as String?,
    readTraitName: json['readTraitName'] as String,
    editTraitName: json['editTraitName'] as String?,
    height: (json['height'] as num).toDouble(),
    property: json['property'] as String,
    staticData: json['staticData'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PNavButtonToJson(PNavButton instance) =>
    <String, dynamic>{
      'version': instance.version,
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
      'route': instance.route,
    };

PNavButtonSet _$PNavButtonSetFromJson(Map<String, dynamic> json) {
  return PNavButtonSet(
    buttons: Map<String, String>.from(json['buttons'] as Map),
    height: (json['height'] as num?)?.toDouble(),
    readTraitName: json['readTraitName'] as String,
    buttonTraitName: json['buttonTraitName'] as String,
  )..version = json['version'] as int;
}

Map<String, dynamic> _$PNavButtonSetToJson(PNavButtonSet instance) =>
    <String, dynamic>{
      'version': instance.version,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'buttons': instance.buttons,
      'buttonTraitName': instance.buttonTraitName,
    };
