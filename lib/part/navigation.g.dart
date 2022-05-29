// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavButton _$NavButtonFromJson(Map<String, dynamic> json) => NavButton(
      route: json['route'] as String,
      caption: json['caption'] as String?,
      traitName: json['traitName'] as String? ?? 'NavButton',
      height: (json['height'] as num?)?.toDouble() ?? 100,
      property: json['property'] as String?,
    );

Map<String, dynamic> _$NavButtonToJson(NavButton instance) => <String, dynamic>{
      'caption': instance.caption,
      'property': instance.property,
      'height': instance.height,
      'traitName': instance.traitName,
      'route': instance.route,
    };

NavButtonSet _$NavButtonSetFromJson(Map<String, dynamic> json) => NavButtonSet(
      buttons: Map<String, String>.from(json['buttons'] as Map),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble() ?? 60,
      pid: json['pid'] as String?,
      traitName: json['traitName'] as String? ?? 'NavButtonSet',
    )..caption = json['caption'] as String?;

Map<String, dynamic> _$NavButtonSetToJson(NavButtonSet instance) =>
    <String, dynamic>{
      'pid': instance.pid,
      'caption': instance.caption,
      'height': instance.height,
      'traitName': instance.traitName,
      'buttons': instance.buttons,
      'width': instance.width,
    };
