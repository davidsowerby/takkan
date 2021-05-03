// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PHeadingStyle _$PHeadingStyleFromJson(Map<String, dynamic> json) {
  return PHeadingStyle(
    textTrait: json['textTrait'] == null
        ? null
        : PTextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
    background: _$enumDecodeNullable(_$PColorEnumMap, json['background']),
    textTheme: _$enumDecodeNullable(_$PTextThemeEnumMap, json['textTheme']),
    height: (json['height'] as num)?.toDouble(),
    elevation: (json['elevation'] as num)?.toDouble(),
    border: json['border'] == null
        ? null
        : PBorder.fromJson(json['border'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PHeadingStyleToJson(PHeadingStyle instance) =>
    <String, dynamic>{
      'textTrait': instance.textTrait?.toJson(),
      'border': instance.border?.toJson(),
      'background': _$PColorEnumMap[instance.background],
      'textTheme': _$PTextThemeEnumMap[instance.textTheme],
      'height': instance.height,
      'elevation': instance.elevation,
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

const _$PColorEnumMap = {
  PColor.primary: 'primary',
  PColor.primaryLight: 'primaryLight',
  PColor.primaryDark: 'primaryDark',
  PColor.accent: 'accent',
  PColor.canvas: 'canvas',
  PColor.card: 'card',
  PColor.highlight: 'highlight',
  PColor.hint: 'hint',
  PColor.error: 'error',
};

const _$PTextThemeEnumMap = {
  PTextTheme.cardCanvas: 'cardCanvas',
  PTextTheme.primary: 'primary',
  PTextTheme.accent: 'accent',
};

PBorder _$PBorderFromJson(Map<String, dynamic> json) {
  return PBorder(
    borderName: json['borderName'] as String,
  );
}

Map<String, dynamic> _$PBorderToJson(PBorder instance) => <String, dynamic>{
      'borderName': instance.borderName,
    };

PBorderDetailed _$PBorderDetailedFromJson(Map<String, dynamic> json) {
  return PBorderDetailed(
    side: json['side'] == null
        ? null
        : PBorderSide.fromJson(json['side'] as Map<String, dynamic>),
    shape: _$enumDecodeNullable(_$PBorderShapeEnumMap, json['shape']),
    sideSet: json['sideSet'] == null
        ? null
        : PBorderSideSet.fromJson(json['sideSet'] as Map<String, dynamic>),
    gapPadding: (json['gapPadding'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PBorderDetailedToJson(PBorderDetailed instance) =>
    <String, dynamic>{
      'shape': _$PBorderShapeEnumMap[instance.shape],
      'side': instance.side?.toJson(),
      'sideSet': instance.sideSet?.toJson(),
      'gapPadding': instance.gapPadding,
    };

const _$PBorderShapeEnumMap = {
  PBorderShape.roundedRectangle: 'roundedRectangle',
  PBorderShape.stadium: 'stadium',
  PBorderShape.outlineInput: 'outlineInput',
  PBorderShape.continuousRectangle: 'continuousRectangle',
  PBorderShape.circle: 'circle',
  PBorderShape.directional: 'directional',
  PBorderShape.underlineInput: 'underlineInput',
  PBorderShape.border: 'border',
  PBorderShape.beveledRectangle: 'beveledRectangle',
};

PBorderSideSet _$PBorderSideSetFromJson(Map<String, dynamic> json) {
  return PBorderSideSet(
    top: json['top'] == null
        ? null
        : PBorderSide.fromJson(json['top'] as Map<String, dynamic>),
    left: json['left'] == null
        ? null
        : PBorderSide.fromJson(json['left'] as Map<String, dynamic>),
    right: json['right'] == null
        ? null
        : PBorderSide.fromJson(json['right'] as Map<String, dynamic>),
    bottom: json['bottom'] == null
        ? null
        : PBorderSide.fromJson(json['bottom'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBorderSideSetToJson(PBorderSideSet instance) =>
    <String, dynamic>{
      'top': instance.top?.toJson(),
      'left': instance.left?.toJson(),
      'right': instance.right?.toJson(),
      'bottom': instance.bottom?.toJson(),
    };

PBorderSide _$PBorderSideFromJson(Map<String, dynamic> json) {
  return PBorderSide(
    color: _$enumDecodeNullable(_$PColorEnumMap, json['color']),
    width: (json['width'] as num)?.toDouble(),
    style: _$enumDecodeNullable(_$PBorderStyleEnumMap, json['style']),
  );
}

Map<String, dynamic> _$PBorderSideToJson(PBorderSide instance) =>
    <String, dynamic>{
      'color': _$PColorEnumMap[instance.color],
      'width': instance.width,
      'style': _$PBorderStyleEnumMap[instance.style],
    };

const _$PBorderStyleEnumMap = {
  PBorderStyle.solid: 'solid',
  PBorderStyle.none: 'none',
};
