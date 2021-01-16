// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pText.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PText _$PTextFromJson(Map<String, dynamic> json) {
  return PText(
    styleName: json['styleName'] as String,
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PTextToJson(PText instance) => <String, dynamic>{
      'styleName': instance.styleName,
      'showCaption': instance.showCaption,
    };
