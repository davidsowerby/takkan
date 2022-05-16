import 'package:json_annotation/json_annotation.dart';
import 'package:takkan_script/script/script.dart';
import 'package:takkan_script/trait/trait.dart';

part 'text_trait.g.dart';

/// Used only if the Trait library is set up remotely (that is, using [Script])
/// Brings together various aspects of styling for text
/// - [textStyle] is an enum representation of Flutter's TextStyle
/// - [textTheme] is an enum representation of Flutter's TextTheme, and in this context indicates the
/// background behind this text
@JsonSerializable(explicitToJson: true)
class TextTrait extends Trait {
  final TextStyle textStyle;
  final TextTheme textTheme;
  final TextAlign textAlign;

  const TextTrait(
      {this.textStyle = TextStyle.bodyText1,
      this.textTheme = TextTheme.cardCanvas,
      this.textAlign = TextAlign.start,
      super.caption});

  factory TextTrait.fromJson(Map<String, dynamic> json) =>
      _$TextTraitFromJson(json);

  Map<String, dynamic> toJson() => _$TextTraitToJson(this);
}

/// Enum representation of Flutter's TextStyle constants
enum TextStyle {
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

/// - Used to select the appropriate text theme depending on the background
/// - [TextTheme.cardCanvas] relates to [ThemeData.textTheme], used when background is a Card or Canvas
/// - [TextTheme.primary] relates to [ThemeData.primaryTextTheme], used when background is the primary color
/// - [TextTheme.accent] relates to [ThemeData.accentTextTheme], used when background is the accent color
enum TextTheme { cardCanvas, primary, accent }

/// This is a direct copy of Flutter's TextAlign, but is used to avoid introducing a direct
/// dependency on Flutter
enum TextAlign {
  /// Align the text on the left edge of the container.
  left,

  /// Align the text on the right edge of the container.
  right,

  /// Align the text in the center of the container.
  center,

  /// Stretch lines of text that end with a soft line break to fill the width of
  /// the container.
  ///
  /// Lines that end with hard line breaks are aligned towards the [start] edge.
  justify,

  /// Align the text on the leading edge of the container.
  ///
  /// For left-to-right text ([TextDirection.ltr]), this is the left edge.
  ///
  /// For right-to-left text ([TextDirection.rtl]), this is the right edge.
  start,

  /// Align the text on the trailing edge of the container.
  ///
  /// For left-to-right text ([TextDirection.ltr]), this is the right edge.
  ///
  /// For right-to-left text ([TextDirection.rtl]), this is the left edge.
  end,
}
