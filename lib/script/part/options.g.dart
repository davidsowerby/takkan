// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PReadModeOptions _$PReadModeOptionsFromJson(Map<String, dynamic> json) {
  return PReadModeOptions(
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PReadModeOptionsToJson(PReadModeOptions instance) =>
    <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
    };

PEditModeOptions _$PEditModeOptionsFromJson(Map<String, dynamic> json) {
  return PEditModeOptions(
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PEditModeOptionsToJson(PEditModeOptions instance) =>
    <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
    };
