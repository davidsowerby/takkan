import 'package:flutter/material.dart';
import 'package:precept_client/library/borderLibrary.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/inject/inject.dart';
import 'package:precept_script/trait/style.dart';
import 'package:precept_script/trait/textTrait.dart';

/// A utility class to enable (decode) the serialization of of a Flutter [TextStyle].  It is assumed
/// that a [Theme] is being used.
abstract class ThemeLookup {
  /// Returns a Flutter [Color] from a Precept [PColor].  A [PColor] is used as a
  /// proxy to 'serialize' a [Color] within a [PScript]
  Color color({required ThemeData theme, required PColor pColor});

  /// Returns a Flutter [TextStyle] from a Precept [PTextStyle].  A [PTextStyle] is used as a
  /// proxy to 'serialize' a [TextStyle] within a [PScript]
  TextStyle textStyle({required ThemeData theme, required PTextStyle style});
}

class DefaultThemeLookup implements ThemeLookup {
  @override
  Color color({required ThemeData theme, required PColor pColor}) {
    switch (pColor) {
      case PColor.primary:
        return theme.primaryColor;
      case PColor.primaryLight:
        return theme.primaryColorLight;
      case PColor.primaryDark:
        return theme.primaryColorDark;
      case PColor.accent:
        return theme.accentColor;
      case PColor.canvas:
        return theme.canvasColor;
      case PColor.card:
        return theme.cardColor;
      default:
        throw PreceptException("Option ${pColor}for background is not recognised");
    }
  }

  @override
  TextStyle textStyle({required ThemeData theme, required PTextStyle style}) {
    TextStyle? ts;
    switch (style) {
      case PTextStyle.headline1:
        ts = theme.textTheme.headline1;
        break;
      case PTextStyle.headline2:
        ts = theme.textTheme.headline2;
        break;
      case PTextStyle.headline3:
        ts = theme.textTheme.headline3;
        break;
      case PTextStyle.headline4:
        ts = theme.textTheme.headline4;
        break;
      case PTextStyle.headline5:
        ts = theme.textTheme.headline5;
        break;
      case PTextStyle.headline6:
        ts = theme.textTheme.headline6;
        break;
      case PTextStyle.subtitle1:
        ts = theme.textTheme.subtitle1;
        break;
      case PTextStyle.subtitle2:
        ts = theme.textTheme.subtitle2;
        break;
      case PTextStyle.bodyText1:
        ts = theme.textTheme.bodyText1;
        break;
      case PTextStyle.bodyText2:
        ts = theme.textTheme.bodyText2;
        break;
      case PTextStyle.caption:
        ts = theme.textTheme.caption;
        break;
      case PTextStyle.button:
        ts = theme.textTheme.button;
        break;
      case PTextStyle.overline:
        ts = theme.textTheme.overline;
        break;
    }
    if (ts != null) return ts;
    throw PreceptException('Theme TextStyle cannot be null');
  }

  ShapeBorder border({required ThemeData theme, required PBorder border}) {
    final library = inject<BorderLibrary>();
    return library.find(theme:theme, border: border);
  }

  ShapeBorder borderDetailed({required ThemeData theme, required PBorderDetailed border}) {
    switch (border.shape) {
      case PBorderShape.roundedRectangle:
        return RoundedRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case PBorderShape.stadium:
        return StadiumBorder(side: _borderSide(theme: theme, border: border));
      case PBorderShape.outlineInput:
        return OutlineInputBorder(
            borderSide: _borderSide(theme: theme, border: border),
            gapPadding: border.gapPadding,
            borderRadius: _borderRadius(border: border));
      case PBorderShape.continuousRectangle:
        return ContinuousRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case PBorderShape.circle:
        return CircleBorder(side: _borderSide(theme: theme, border: border));
      case PBorderShape.directional:
        return BorderDirectional(); // top, bottom ,start, end
      case PBorderShape.underlineInput:
        return UnderlineInputBorder(
            borderSide: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
      case PBorderShape.border:
        return Border(); // BorderSide top, right, left, bottom
      case PBorderShape.beveledRectangle:
        return BeveledRectangleBorder(
            side: _borderSide(theme: theme, border: border),
            borderRadius: _borderRadius(border: border));
    }
  }

  BorderSide _borderSide({required ThemeData theme, required PBorderDetailed border}) {
    return BorderSide(
        color: color(theme: theme, pColor: border.side.color),
        width: border.side.width,
        style: _borderStyle(pStyle: border.side.style));
  }

  BorderStyle _borderStyle({required PBorderStyle pStyle}) {
    return (pStyle == PBorderStyle.solid) ? BorderStyle.solid : BorderStyle.none;
  }

  BorderRadius _borderRadius({required PBorderDetailed border}) {
    logType(this.runtimeType).w(
        "_borderRadius not implemented, just returns a default value"); // TODO  https://gitlab.com/precept1/precept-client/-/issues/6
    return BorderRadius.all(Radius.circular(5));
  }
}
