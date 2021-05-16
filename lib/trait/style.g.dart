// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PHeadingStyle _$PHeadingStyleFromJson(Map<String, dynamic> json) {
  return PHeadingStyle(
    textTrait: PTextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
    background: _$enumDecode(_$PColorEnumMap, json['background']),
    textTheme: _$enumDecode(_$PTextThemeEnumMap, json['textTheme']),
    height: (json['height'] as num).toDouble(),
    elevation: (json['elevation'] as num).toDouble(),
    border: PBorder.fromJson(json['border'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PHeadingStyleToJson(PHeadingStyle instance) =>
    <String, dynamic>{
      'textTrait': instance.textTrait.toJson(),
      'border': instance.border.toJson(),
      'background': _$PColorEnumMap[instance.background],
      'textTheme': _$PTextThemeEnumMap[instance.textTheme],
      'height': instance.height,
      'elevation': instance.elevation,
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
    side: PBorderSide.fromJson(json['side'] as Map<String, dynamic>),
    shape: _$enumDecode(_$PBorderShapeEnumMap, json['shape']),
    sideSet: json['sideSet'] == null
        ? null
        : PBorderSideSet.fromJson(json['sideSet'] as Map<String, dynamic>),
    gapPadding: (json['gapPadding'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PBorderDetailedToJson(PBorderDetailed instance) =>
    <String, dynamic>{
      'shape': _$PBorderShapeEnumMap[instance.shape],
      'side': instance.side.toJson(),
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
    top: PBorderSide.fromJson(json['top'] as Map<String, dynamic>),
    left: PBorderSide.fromJson(json['left'] as Map<String, dynamic>),
    right: PBorderSide.fromJson(json['right'] as Map<String, dynamic>),
    bottom: PBorderSide.fromJson(json['bottom'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PBorderSideSetToJson(PBorderSideSet instance) =>
    <String, dynamic>{
      'top': instance.top.toJson(),
      'left': instance.left.toJson(),
      'right': instance.right.toJson(),
      'bottom': instance.bottom.toJson(),
    };

PBorderSide _$PBorderSideFromJson(Map<String, dynamic> json) {
  return PBorderSide(
    color: _$enumDecode(_$PColorEnumMap, json['color']),
    width: (json['width'] as num).toDouble(),
    style: _$enumDecode(_$PBorderStyleEnumMap, json['style']),
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
