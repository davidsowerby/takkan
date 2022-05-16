import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/trait/text_trait.dart';

part 'style.g.dart';

/// Declares a heading style based upon the current [Theme]
///
/// [textTrait] selects a text style from the [Theme]
/// [background] sets the background color of the container behind the text, using the current [Theme]
/// [textTheme] relates to the background in use, see [TextTheme],
///
@JsonSerializable(explicitToJson: true)
class HeadingStyle {
  final TextTrait textTrait;
  final Border border;
  final Color background;
  final TextTheme textTheme;
  final double height;
  final double elevation;

  const HeadingStyle({
    this.textTrait = const TextTrait(textStyle: TextStyle.subtitle1),
    this.background = Color.canvas,
    this.textTheme = TextTheme.cardCanvas,
    this.height = 40,
    this.elevation = 20,
    this.border = const Border(),
  });

  factory HeadingStyle.fromJson(Map<String, dynamic> json) =>
      _$HeadingStyleFromJson(json);

  Map<String, dynamic> toJson() => _$HeadingStyleToJson(this);
}

/// - [TextTheme.cardCanvas] relates to [ThemeData.textTheme], used when background is a Card or Canvas
/// - [TextTheme.primary] relates to [ThemeData.primaryTextTheme], used when background is the primary color
/// - [TextTheme.accent] relates to [ThemeData.accentTextTheme], used when background is the accent color
/// - [TextTheme.auto] is used to select one of the above depending on the background
///

enum Color {
  primary,
  primaryLight,
  primaryDark,
  accent,
  canvas,
  card,
  highlight,
  hint,
  error
}

enum BorderShape {
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
/// See also [BorderDetailed] to define a border from scratch
@JsonSerializable(explicitToJson: true)
class Border {
  static const String roundedRectangleThinPrimary =
      "roundedRectangleThinPrimary";
  static const String roundedRectangleMediumPrimary =
      "roundedRectangleMediumPrimary";
  static const String roundedRectangleThickPrimary =
      "roundedRectangleThickPrimary";
  final String borderName;

  const Border({this.borderName = 'roundedRectangleMediumPrimary'});

  factory Border.fromJson(Map<String, dynamic> json) => _$BorderFromJson(json);

  Map<String, dynamic> toJson() => _$BorderToJson(this);
}

/// A detailed border definition.  See also [Border] for predefined borders.
///
/// - [shape] selects the required shape, as defined by Flutter
/// - [side] a single side is defined for all [shape]s except [BorderShape.directional] and [BorderShape.border]
/// - [sideSet] is used only with [BorderShape.directional] and [BorderShape.border]
/// - [gapPadding] is used only with [BorderShape.outlineInput]
@JsonSerializable(explicitToJson: true)
class BorderDetailed {
  final BorderShape shape;
  final BorderSide side;
  final BorderSideSet? sideSet;

  final double gapPadding;

  const BorderDetailed(
      {this.side = const BorderSide(),
      this.shape = BorderShape.roundedRectangle,
      this.sideSet,
      this.gapPadding = 4.0});

  factory BorderDetailed.fromJson(Map<String, dynamic> json) =>
      _$BorderDetailedFromJson(json);

  Map<String, dynamic> toJson() => _$BorderDetailedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BorderSideSet {
  final BorderSide top;
  final BorderSide left;
  final BorderSide right;
  final BorderSide bottom;

  const BorderSideSet(
      {this.top = const BorderSide(),
      this.left = const BorderSide(),
      this.right = const BorderSide(),
      this.bottom = const BorderSide()});

  factory BorderSideSet.fromJson(Map<String, dynamic> json) =>
      _$BorderSideSetFromJson(json);

  Map<String, dynamic> toJson() => _$BorderSideSetToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BorderSide {
  final Color color;
  final double width;
  final BorderStyle style;

  const BorderSide(
      {this.color = Color.primary,
      this.width = 5,
      this.style = BorderStyle.solid});

  factory BorderSide.fromJson(Map<String, dynamic> json) =>
      _$BorderSideFromJson(json);

  Map<String, dynamic> toJson() => _$BorderSideToJson(this);
}

enum BorderStyle { solid, none }
