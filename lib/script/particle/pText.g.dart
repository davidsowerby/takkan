// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pText.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PText _$PTextFromJson(Map<String, dynamic> json) {
  return PText(
    textTrait: json['textTrait'] == null
        ? null
        : PTextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PTextToJson(PText instance) => <String, dynamic>{
      'showCaption': instance.showCaption,
      'textTrait': instance.textTrait?.toJson(),
    };
