// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PNavigationButton _$PNavigationButtonFromJson(Map<String, dynamic> json) {
  return PNavigationButton(
    route: json['route'] as String,
    args: json['args'] as Map<String, dynamic>,
    caption: json['caption'] as String,
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PNavigationButtonToJson(PNavigationButton instance) =>
    <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
      'route': instance.route,
      'caption': instance.caption,
      'args': instance.args,
    };
