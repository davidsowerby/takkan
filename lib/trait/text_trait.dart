import 'package:json_annotation/json_annotation.dart';
import 'package:precept_script/script/script.dart';
import 'package:precept_script/trait/trait.dart';

part 'text_trait.g.dart';

/// Used only if the Trait library is set up remotely (that is, using [PScript])
/// Brings together various aspects of styling for text
/// - [textStyle] is an enum representation of Flutter's TextStyle
/// - [textTheme] is an enum representation of Flutter's TextTheme, and in this context indicates the
/// background behind this text
@JsonSerializable( explicitToJson: true)
class PTextTrait extends PTrait {
  final PTextStyle textStyle;
  final PTextTheme textTheme;
  final PTextAlign textAlign;

  const PTextTrait(
      {this.textStyle = PTextStyle.bodyText1,
      this.textTheme = PTextTheme.cardCanvas,
      this.textAlign = PTextAlign.start,
      String? caption})
      : super(caption: caption);

  factory PTextTrait.fromJson(Map<String, dynamic> json) => _$PTextTraitFromJson(json);

  Map<String, dynamic> toJson() => _$PTextTraitToJson(this);
}

/// Enum representation of Flutter's TextStyle constants
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

/// - Used to select the appropriate text theme depending on the background
/// - [PTextTheme.cardCanvas] relates to [ThemeData.textTheme], used when background is a Card or Canvas
/// - [PTextTheme.primary] relates to [ThemeData.primaryTextTheme], used when background is the primary color
/// - [PTextTheme.accent] relates to [ThemeData.accentTextTheme], used when background is the accent color
enum PTextTheme { cardCanvas, primary, accent }

/// This is a direct copy of Flutter's TextAlign, but is used to avoid introducing a direct
/// dependency on Flutter
enum PTextAlign {
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
