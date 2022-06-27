// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavButton _$NavButtonFromJson(Map<String, dynamic> json) => NavButton(
      toPage: json['toPage'] as String,
      toData: json['toData'] as String,
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
      'toPage': instance.toPage,
      'toData': instance.toData,
    };

NavButtonSet _$NavButtonSetFromJson(Map<String, dynamic> json) => NavButtonSet(
      buttons: (json['buttons'] as List<dynamic>)
          .map((e) => NavButton.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'buttons': instance.buttons.map((e) => e.toJson()).toList(),
      'width': instance.width,
    };
