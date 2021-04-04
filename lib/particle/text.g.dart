// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PText _$PTextFromJson(Map<String, dynamic> json) {
  return PText(
    traitName: json['traitName'] as String,
    background: _$enumDecodeNullable(_$PTextThemeEnumMap, json['background']),
    showCaption: json['showCaption'] as bool,
  );
}

Map<String, dynamic> _$PTextToJson(PText instance) => <String, dynamic>{
      'showCaption': instance.showCaption,
      'traitName': instance.traitName,
      'background': _$PTextThemeEnumMap[instance.background],
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

const _$PTextThemeEnumMap = {
  PTextTheme.standard: 'standard',
  PTextTheme.primary: 'primary',
  PTextTheme.accent: 'accent',
};
