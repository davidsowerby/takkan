// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textTrait.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PTextTrait _$PTextTraitFromJson(Map<String, dynamic> json) => PTextTrait(
      textStyle: _$enumDecodeNullable(_$PTextStyleEnumMap, json['textStyle']) ??
          PTextStyle.bodyText1,
      textTheme: _$enumDecodeNullable(_$PTextThemeEnumMap, json['textTheme']) ??
          PTextTheme.cardCanvas,
      textAlign: _$enumDecodeNullable(_$PTextAlignEnumMap, json['textAlign']) ??
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

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

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
