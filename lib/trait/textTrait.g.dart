// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textTrait.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PTextTrait _$PTextTraitFromJson(Map<String, dynamic> json) {
  return PTextTrait(
    textStyle: _$enumDecodeNullable(_$PTextStyleEnumMap, json['textStyle']),
    textTheme: _$enumDecodeNullable(_$PTextThemeEnumMap, json['textTheme']),
    textAlign: _$enumDecodeNullable(_$PTextAlignEnumMap, json['textAlign']),
  );
}

Map<String, dynamic> _$PTextTraitToJson(PTextTrait instance) =>
    <String, dynamic>{
      'textStyle': _$PTextStyleEnumMap[instance.textStyle],
      'textTheme': _$PTextThemeEnumMap[instance.textTheme],
      'textAlign': _$PTextAlignEnumMap[instance.textAlign],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
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
  PTextTheme.standard: 'standard',
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
