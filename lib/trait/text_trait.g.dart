// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_trait.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTrait _$TextTraitFromJson(Map<String, dynamic> json) => TextTrait(
      textStyle: $enumDecodeNullable(_$TextStyleEnumMap, json['textStyle']) ??
          TextStyle.bodyText1,
      textTheme: $enumDecodeNullable(_$TextThemeEnumMap, json['textTheme']) ??
          TextTheme.cardCanvas,
      textAlign: $enumDecodeNullable(_$TextAlignEnumMap, json['textAlign']) ??
          TextAlign.start,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$TextTraitToJson(TextTrait instance) => <String, dynamic>{
      'caption': instance.caption,
      'textStyle': _$TextStyleEnumMap[instance.textStyle],
      'textTheme': _$TextThemeEnumMap[instance.textTheme],
      'textAlign': _$TextAlignEnumMap[instance.textAlign],
    };

const _$TextStyleEnumMap = {
  TextStyle.headline1: 'headline1',
  TextStyle.headline2: 'headline2',
  TextStyle.headline3: 'headline3',
  TextStyle.headline4: 'headline4',
  TextStyle.headline5: 'headline5',
  TextStyle.headline6: 'headline6',
  TextStyle.subtitle1: 'subtitle1',
  TextStyle.subtitle2: 'subtitle2',
  TextStyle.bodyText1: 'bodyText1',
  TextStyle.bodyText2: 'bodyText2',
  TextStyle.caption: 'caption',
  TextStyle.button: 'button',
  TextStyle.overline: 'overline',
};

const _$TextThemeEnumMap = {
  TextTheme.cardCanvas: 'cardCanvas',
  TextTheme.primary: 'primary',
  TextTheme.accent: 'accent',
};

const _$TextAlignEnumMap = {
  TextAlign.left: 'left',
  TextAlign.right: 'right',
  TextAlign.center: 'center',
  TextAlign.justify: 'justify',
  TextAlign.start: 'start',
  TextAlign.end: 'end',
};
