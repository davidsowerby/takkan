import 'package:flutter/material.dart';
import 'package:takkan_client/library/border_library.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/inject/inject.dart';
import 'package:takkan_script/trait/style.dart' as StyleConfig;
import 'package:takkan_script/trait/text_trait.dart' as TextTraitConfig;

/// A utility class to enable (decode) the serialization of of a Flutter [TextStyle].  It is assumed
/// that a [Theme] is being used.
abstract class ThemeLookup {
  /// Returns a Flutter [Color] from a Takkan [PColor].  A [PColor] is used as a
  /// proxy to 'serialize' a [Color] within a [Script]
  Color color({required ThemeData theme, required StyleConfig.Color pColor});

  /// Returns a Flutter [TextStyle] from a Takkan [PTextStyle].  A [PTextStyle] is used as a
  /// proxy to 'serialize' a [TextStyle] within a [Script]
  TextStyle textStyle(
      {required ThemeData theme, required TextTraitConfig.TextStyle style});
}

class DefaultThemeLookup implements ThemeLookup {
  @override
  Color color({required ThemeData theme, required StyleConfig.Color pColor}) {
    switch (pColor) {
      case StyleConfig.Color.primary:
        return theme.primaryColor;
      case StyleConfig.Color.primaryLight:
        return theme.primaryColorLight;
      case StyleConfig.Color.primaryDark:
        return theme.primaryColorDark;
      case StyleConfig.Color.accent:
        return theme.accentColor;
      case StyleConfig.Color.canvas:
        return theme.canvasColor;
      case StyleConfig.Color.card:
        return theme.cardColor;
      default:
        throw TakkanException(
            "Option ${pColor}for background is not recognised");
    }
  }

  @override
  TextStyle textStyle(
      {required ThemeData theme, required TextTraitConfig.TextStyle style}) {
    TextStyle? ts;
    switch (style) {
      case TextTraitConfig.TextStyle.headline1:
        ts = theme.textTheme.headline1;
        break;
      case TextTraitConfig.TextStyle.headline2:
        ts = theme.textTheme.headline2;
        break;
      case TextTraitConfig.TextStyle.headline3:
        ts = theme.textTheme.headline3;
        break;
      case TextTraitConfig.TextStyle.headline4:
        ts = theme.textTheme.headline4;
        break;
      case TextTraitConfig.TextStyle.headline5:
        ts = theme.textTheme.headline5;
        break;
      case TextTraitConfig.TextStyle.headline6:
        ts = theme.textTheme.headline6;
        break;
      case TextTraitConfig.TextStyle.subtitle1:
        ts = theme.textTheme.subtitle1;
        break;
      case TextTraitConfig.TextStyle.subtitle2:
        ts = theme.textTheme.subtitle2;
        break;
      case TextTraitConfig.TextStyle.bodyText1:
        ts = theme.textTheme.bodyText1;
        break;
      case TextTraitConfig.TextStyle.bodyText2:
        ts = theme.textTheme.bodyText2;
        break;
      case TextTraitConfig.TextStyle.caption:
        ts = theme.textTheme.caption;
        break;
      case TextTraitConfig.TextStyle.button:
        ts = theme.textTheme.button;
        break;
      case TextTraitConfig.TextStyle.overline:
        ts = theme.textTheme.overline;
        break;
    }
    if (ts != null) return ts;
    throw TakkanException('Theme TextStyle cannot be null');
  }

  ShapeBorder border(
      {required ThemeData theme, required StyleConfig.Border border}) {
    final library = inject<BorderLibrary>();
    return library.find(theme: theme, border: border);
  }

  ShapeBorder borderDetailed(
      {required ThemeData theme, required StyleConfig.BorderDetailed border}) {
    switch (border.shape) {
      case StyleConfig.BorderShape.roundedRectangle:
        return RoundedRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case StyleConfig.BorderShape.stadium:
        return StadiumBorder(side: _borderSide(theme: theme, border: border));
      case StyleConfig.BorderShape.outlineInput:
        return OutlineInputBorder(
            borderSide: _borderSide(theme: theme, border: border),
            gapPadding: border.gapPadding,
            borderRadius: _borderRadius(border: border));
      case StyleConfig.BorderShape.continuousRectangle:
        return ContinuousRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case StyleConfig.BorderShape.circle:
        return CircleBorder(side: _borderSide(theme: theme, border: border));
      case StyleConfig.BorderShape.directional:
        return BorderDirectional(); // top, bottom ,start, end
      case StyleConfig.BorderShape.underlineInput:
        return UnderlineInputBorder(
            borderSide: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case StyleConfig.BorderShape.border:
        return Border(); // BorderSide top, right, left, bottom
      case StyleConfig.BorderShape.beveledRectangle:
        return BeveledRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
    }
  }

  BorderSide _borderSide(
      {required ThemeData theme, required StyleConfig.BorderDetailed border}) {
    return BorderSide(
        color: color(theme: theme, pColor: border.side.color),
        width: border.side.width,
        style: _borderStyle(pStyle: border.side.style));
  }

  BorderStyle _borderStyle({required StyleConfig.BorderStyle pStyle}) {
    return (pStyle == StyleConfig.BorderStyle.solid)
        ? BorderStyle.solid
        : BorderStyle.none;
  }

  BorderRadius _borderRadius({required StyleConfig.BorderDetailed border}) {
    logType(this.runtimeType).w(
        "_borderRadius not implemented, just returns a default value"); // TODO  https://gitlab.com/takkan_/takkan-client/-/issues/6
    return BorderRadius.all(Radius.circular(5));
  }
}
