// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PNavButton _$PNavButtonFromJson(Map<String, dynamic> json) => PNavButton(
      readOnly: json['readOnly'] as bool? ?? false,
      route: json['route'] as String,
      caption: json['caption'] as String?,
      readTraitName:
          json['readTraitName'] as String? ?? 'queryView-read-default',
      editTraitName:
          json['editTraitName'] as String? ?? 'queryView-edit-default',
      height: (json['height'] as num).toDouble(),
      property: json['property'] as String? ?? notSet,
      staticData: json['staticData'] as String,
      pid: json['pid'] as String?,
    )..version = json['version'] as int;

Map<String, dynamic> _$PNavButtonToJson(PNavButton instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pid': instance.pid,
      'caption': instance.caption,
      'property': instance.property,
      'readOnly': instance.readOnly,
      'staticData': instance.staticData,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'editTraitName': instance.editTraitName,
      'route': instance.route,
    };

PNavButtonSet _$PNavButtonSetFromJson(Map<String, dynamic> json) =>
    PNavButtonSet(
      buttons: Map<String, String>.from(json['buttons'] as Map),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      pid: json['pid'] as String?,
      readTraitName:
          json['readTraitName'] as String? ?? 'queryView-read-default',
      buttonTraitName:
          json['buttonTraitName'] as String? ?? 'PNavButton-default',
    )..version = json['version'] as int;

Map<String, dynamic> _$PNavButtonSetToJson(PNavButtonSet instance) =>
    <String, dynamic>{
      'version': instance.version,
      'pid': instance.pid,
      'height': instance.height,
      'readTraitName': instance.readTraitName,
      'buttons': instance.buttons,
      'buttonTraitName': instance.buttonTraitName,
      'width': instance.width,
    };
