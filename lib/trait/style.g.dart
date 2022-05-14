// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeadingStyle _$HeadingStyleFromJson(Map<String, dynamic> json) => HeadingStyle(
      textTrait: json['textTrait'] == null
          ? const TextTrait(textStyle: TextStyle.subtitle1)
          : TextTrait.fromJson(json['textTrait'] as Map<String, dynamic>),
      background: $enumDecodeNullable(_$ColorEnumMap, json['background']) ??
          Color.canvas,
      textTheme: $enumDecodeNullable(_$TextThemeEnumMap, json['textTheme']) ??
          TextTheme.cardCanvas,
      height: (json['height'] as num?)?.toDouble() ?? 40,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 20,
      border: json['border'] == null
          ? const Border()
          : Border.fromJson(json['border'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeadingStyleToJson(HeadingStyle instance) =>
    <String, dynamic>{
      'textTrait': instance.textTrait.toJson(),
      'border': instance.border.toJson(),
      'background': _$ColorEnumMap[instance.background],
      'textTheme': _$TextThemeEnumMap[instance.textTheme],
      'height': instance.height,
      'elevation': instance.elevation,
    };

const _$ColorEnumMap = {
  Color.primary: 'primary',
  Color.primaryLight: 'primaryLight',
  Color.primaryDark: 'primaryDark',
  Color.accent: 'accent',
  Color.canvas: 'canvas',
  Color.card: 'card',
  Color.highlight: 'highlight',
  Color.hint: 'hint',
  Color.error: 'error',
};

const _$TextThemeEnumMap = {
  TextTheme.cardCanvas: 'cardCanvas',
  TextTheme.primary: 'primary',
  TextTheme.accent: 'accent',
};

Border _$BorderFromJson(Map<String, dynamic> json) => Border(
      borderName:
          json['borderName'] as String? ?? 'roundedRectangleMediumPrimary',
    );

Map<String, dynamic> _$BorderToJson(Border instance) => <String, dynamic>{
      'borderName': instance.borderName,
    };

BorderDetailed _$BorderDetailedFromJson(Map<String, dynamic> json) =>
    BorderDetailed(
      side: json['side'] == null
          ? const BorderSide()
          : BorderSide.fromJson(json['side'] as Map<String, dynamic>),
      shape: $enumDecodeNullable(_$BorderShapeEnumMap, json['shape']) ??
          BorderShape.roundedRectangle,
      sideSet: json['sideSet'] == null
          ? null
          : BorderSideSet.fromJson(json['sideSet'] as Map<String, dynamic>),
      gapPadding: (json['gapPadding'] as num?)?.toDouble() ?? 4.0,
    );

Map<String, dynamic> _$BorderDetailedToJson(BorderDetailed instance) =>
    <String, dynamic>{
      'shape': _$BorderShapeEnumMap[instance.shape],
      'side': instance.side.toJson(),
      'sideSet': instance.sideSet?.toJson(),
      'gapPadding': instance.gapPadding,
    };

const _$BorderShapeEnumMap = {
  BorderShape.roundedRectangle: 'roundedRectangle',
  BorderShape.stadium: 'stadium',
  BorderShape.outlineInput: 'outlineInput',
  BorderShape.continuousRectangle: 'continuousRectangle',
  BorderShape.circle: 'circle',
  BorderShape.directional: 'directional',
  BorderShape.underlineInput: 'underlineInput',
  BorderShape.border: 'border',
  BorderShape.beveledRectangle: 'beveledRectangle',
};

BorderSideSet _$BorderSideSetFromJson(Map<String, dynamic> json) =>
    BorderSideSet(
      top: json['top'] == null
          ? const BorderSide()
          : BorderSide.fromJson(json['top'] as Map<String, dynamic>),
      left: json['left'] == null
          ? const BorderSide()
          : BorderSide.fromJson(json['left'] as Map<String, dynamic>),
      right: json['right'] == null
          ? const BorderSide()
          : BorderSide.fromJson(json['right'] as Map<String, dynamic>),
      bottom: json['bottom'] == null
          ? const BorderSide()
          : BorderSide.fromJson(json['bottom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BorderSideSetToJson(BorderSideSet instance) =>
    <String, dynamic>{
      'top': instance.top.toJson(),
      'left': instance.left.toJson(),
      'right': instance.right.toJson(),
      'bottom': instance.bottom.toJson(),
    };

BorderSide _$BorderSideFromJson(Map<String, dynamic> json) => BorderSide(
      color:
          $enumDecodeNullable(_$ColorEnumMap, json['color']) ?? Color.primary,
      width: (json['width'] as num?)?.toDouble() ?? 5,
      style: $enumDecodeNullable(_$BorderStyleEnumMap, json['style']) ??
          BorderStyle.solid,
    );

Map<String, dynamic> _$BorderSideToJson(BorderSide instance) =>
    <String, dynamic>{
      'color': _$ColorEnumMap[instance.color],
      'width': instance.width,
      'style': _$BorderStyleEnumMap[instance.style],
    };

const _$BorderStyleEnumMap = {
  BorderStyle.solid: 'solid',
  BorderStyle.none: 'none',
};
