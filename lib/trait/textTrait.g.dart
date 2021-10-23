// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textTrait.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PTextTrait _$PTextTraitFromJson(Map<String, dynamic> json) => PTextTrait(
      textStyle: $enumDecodeNullable(_$PTextStyleEnumMap, json['textStyle']) ??
          PTextStyle.bodyText1,
      textTheme: $enumDecodeNullable(_$PTextThemeEnumMap, json['textTheme']) ??
          PTextTheme.cardCanvas,
      textAlign: $enumDecodeNullable(_$PTextAlignEnumMap, json['textAlign']) ??
          PTextAlign.start,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$PTextTraitToJson(PTextTrait instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'textStyle': _$PTextStyleEnumMap[instance.textStyle],
      'textTheme': _$PTextThemeEnumMap[instance.textTheme],
      'textAlign': _$PTextAlignEnumMap[instance.textAlign],
    };

const _$PTextStyleEnumMap = {
  PTextStyle.headline1: 'headline1',
  PTextStyle.headline2: 'headline2',
  PTextStyle.headline3: 'headline3',
  PTextStyle.headline4: 'headline4',
  PTextStyle.headline5: 'headline5',
  PTextStyle.headline6: 'headline6',
  PTextStyle.subtitle1: 'subtitle1',
  PTextStyle.subtitle2: 'subtitle2',
  PTextStyle.bodyText1: 'bodyText1',
  PTextStyle.bodyText2: 'bodyText2',
  PTextStyle.caption: 'caption',
  PTextStyle.button: 'button',
  PTextStyle.overline: 'overline',
};

const _$PTextThemeEnumMap = {
  PTextTheme.cardCanvas: 'cardCanvas',
  PTextTheme.primary: 'primary',
  PTextTheme.accent: 'accent',
};

const _$PTextAlignEnumMap = {
  PTextAlign.left: 'left',
  PTextAlign.right: 'right',
  PTextAlign.center: 'center',
  PTextAlign.justify: 'justify',
  PTextAlign.start: 'start',
  PTextAlign.end: 'end',
};
