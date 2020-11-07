import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'style.g.dart';

/// Declares a heading style based upon the current [Theme]
///
/// [style] selects a text style from the [Theme]
/// [background] sets the background color of the container behind the text, using the current [Theme]
/// [textTheme] is generally used as follows:
/// - [PTextTheme.standard] relates to [ThemeData.textTheme], used when background is a Card or Canvas
/// - [PTextTheme.primary] relates to [ThemeData.primaryTextTheme], used when background is the primary color
/// - [PTextTheme.accent] relates to [ThemeData.accentTextTheme], used when background is the accent color
@JsonSerializable(nullable: true, explicitToJson: true)
class PHeadingStyle {
  final PTextStyle style;
  final PBorder border;
  final PColor background;
  final PTextTheme textTheme;
  final double height;
  final double elevation;

  const PHeadingStyle({
    this.style = PTextStyle.subtitle1,
    this.background = PColor.canvas,
    this.textTheme = PTextTheme.standard,
    this.height = 40,
    this.elevation = 20,
    this.border=const PBorder(),
  });

  factory PHeadingStyle.fromJson(Map<String, dynamic> json) => _$PHeadingStyleFromJson(json);

  Map<String, dynamic> toJson() => _$PHeadingStyleToJson(this);
}

enum PTextStyle {
  headline1,
  headline2,
  headline3,
  headline4,
  headline5,
  headline6,
  subtitle1,
  subtitle2,
  bodyText1,
  bodyText2,
  caption,
  button,
  overline,
}

enum PTextTheme { standard, primary, accent }
enum PColor { primary, primaryLight, primaryDark, accent, canvas, card, highlight, hint, error }

enum PBorderShape {
  roundedRectangle,
  stadium,
  outlineInput,
  continuousRectangle,
  circle,
  directional,
  underlineInput,
  border,
  beveledRectangle,
}

/// A border that you have already defined in code, and made available to the
/// [BorderLibrary].
///
/// - [borderName] is the key used to look up the border from [BorderLibrary]
///
/// See also [PBorderDetailed] to define a border from scratch
@JsonSerializable(nullable: true, explicitToJson: true)
class PBorder {
  static const String roundedRectangleThinPrimary="roundedRectangleThinPrimary";
  static const String roundedRectangleMediumPrimary="roundedRectangleMediumPrimary";
  static const String roundedRectangleThickPrimary="roundedRectangleThickPrimary";
  final String borderName;

  const PBorder({this.borderName=roundedRectangleMediumPrimary});

  factory PBorder.fromJson(Map<String, dynamic> json) => _$PBorderFromJson(json);

  Map<String, dynamic> toJson() => _$PBorderToJson(this);
}

/// A detailed border definition.  See also [PBorder] for predefined borders.
///
/// - [shape] selects the required shape, as defined by Flutter
/// - [side] a single side is defined for all [shape]s except [PBorderShape.directional] and [PBorderShape.border]
/// - [sideSet] is used only with [PBorderShape.directional] and [PBorderShape.border]
/// - [gapPadding] is used only with [PBorderShape.outlineInput]
@JsonSerializable(nullable: true, explicitToJson: true)
class PBorderDetailed {
  final PBorderShape shape;
  final PBorderSide side;
  final PBorderSideSet sideSet;

  final double gapPadding;

  const PBorderDetailed(
      {this.side = const PBorderSide(),
      this.shape = PBorderShape.roundedRectangle,
      this.sideSet,
      this.gapPadding = 4.0});

  factory PBorderDetailed.fromJson(Map<String, dynamic> json) => _$PBorderDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$PBorderDetailedToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PBorderSideSet {
  final PBorderSide top;
  final PBorderSide left;
  final PBorderSide right;
  final PBorderSide bottom;

  const PBorderSideSet(
      {this.top = const PBorderSide(),
      this.left = const PBorderSide(),
      this.right = const PBorderSide(),
      this.bottom = const PBorderSide()});

  factory PBorderSideSet.fromJson(Map<String, dynamic> json) => _$PBorderSideSetFromJson(json);

  Map<String, dynamic> toJson() => _$PBorderSideSetToJson(this);
}

@JsonSerializable(nullable: true, explicitToJson: true)
class PBorderSide {
  final PColor color;
  final double width;
  final PBorderStyle style;

  const PBorderSide({this.color = PColor.primary, this.width = 5, this.style = PBorderStyle.solid});

  factory PBorderSide.fromJson(Map<String, dynamic> json) => _$PBorderSideFromJson(json);

  Map<String, dynamic> toJson() => _$PBorderSideToJson(this);
}

enum PBorderStyle { solid, none }
