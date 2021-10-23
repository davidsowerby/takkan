// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PHeadingStyle _$PHeadingStyleFromJson(Map<String, dynamic> json) =>
    PHeadingStyle(
      textTrait: json['textTrait'] == null
          ? const PTextTrait(textStyle: PTextStyle.subtitle1)
          : PTextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
      background: $enumDecodeNullable(_$PColorEnumMap, json['background']) ??
          PColor.canvas,
      textTheme: $enumDecodeNullable(_$PTextThemeEnumMap, json['textTheme']) ??
          PTextTheme.cardCanvas,
      height: (json['height'] as num?)?.toDouble() ?? 40,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 20,
      border: json['border'] == null
          ? const PBorder()
          : PBorder.fromJson(json['border'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PHeadingStyleToJson(PHeadingStyle instance) =>
    <String, dynamic>{
      'textTrait': instance.textTrait.toJson(),
      'border': instance.border.toJson(),
      'background': _$PColorEnumMap[instance.background],
      'textTheme': _$PTextThemeEnumMap[instance.textTheme],
      'height': instance.height,
      'elevation': instance.elevation,
    };

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

PBorder _$PBorderFromJson(Map<String, dynamic> json) => PBorder(
      borderName:
          json['borderName'] as String? ?? 'roundedRectangleMediumPrimary',
    );

Map<String, dynamic> _$PBorderToJson(PBorder instance) => <String, dynamic>{
      'borderName': instance.borderName,
    };

PBorderDetailed _$PBorderDetailedFromJson(Map<String, dynamic> json) =>
    PBorderDetailed(
      side: json['side'] == null
          ? const PBorderSide()
          : PBorderSide.fromJson(json['side'] as Map<String, dynamic>),
      shape: $enumDecodeNullable(_$PBorderShapeEnumMap, json['shape']) ??
          PBorderShape.roundedRectangle,
      sideSet: json['sideSet'] == null
          ? null
          : PBorderSideSet.fromJson(json['sideSet'] as Map<String, dynamic>),
      gapPadding: (json['gapPadding'] as num?)?.toDouble() ?? 4.0,
    );

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

PBorderSideSet _$PBorderSideSetFromJson(Map<String, dynamic> json) =>
    PBorderSideSet(
      top: json['top'] == null
          ? const PBorderSide()
          : PBorderSide.fromJson(json['top'] as Map<String, dynamic>),
      left: json['left'] == null
          ? const PBorderSide()
          : PBorderSide.fromJson(json['left'] as Map<String, dynamic>),
      right: json['right'] == null
          ? const PBorderSide()
          : PBorderSide.fromJson(json['right'] as Map<String, dynamic>),
      bottom: json['bottom'] == null
          ? const PBorderSide()
          : PBorderSide.fromJson(json['bottom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PBorderSideSetToJson(PBorderSideSet instance) =>
    <String, dynamic>{
      'top': instance.top.toJson(),
      'left': instance.left.toJson(),
      'right': instance.right.toJson(),
      'bottom': instance.bottom.toJson(),
    };

PBorderSide _$PBorderSideFromJson(Map<String, dynamic> json) => PBorderSide(
      color:
          $enumDecodeNullable(_$PColorEnumMap, json['color']) ?? PColor.primary,
      width: (json['width'] as num?)?.toDouble() ?? 5,
      style: $enumDecodeNullable(_$PBorderStyleEnumMap, json['style']) ??
          PBorderStyle.solid,
    );

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
