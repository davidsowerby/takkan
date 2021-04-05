import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:precept_script/particle/text.dart';
import 'package:precept_script/trait/textTrait.dart';

class TraitLibrary {
  final Map<String, TextTrait> _textTraits = Map();
  final Map<String, PTextTrait> _pTextTraits = Map();

  TextTrait textTrait(
      {@required ThemeData theme,
      @required PText config}) {
    final textTheme = _lookupTextTheme(theme, config.background);
    switch (config.traitName) {
      case 'heading 1':
        return TextTrait(
          textStyle: textTheme.headline4,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case 'heading 2':
        return TextTrait(
          textStyle: textTheme.headline5,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case 'heading 3':
        return TextTrait(
          textStyle: textTheme.headline6,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case 'body text':
        return TextTrait(
          textStyle: textTheme.bodyText1,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
      default:
        return TextTrait(
          textStyle: textTheme.bodyText1,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
    }
  }
}

TextTheme _lookupTextTheme(ThemeData theme, PTextTheme background) {
  switch (background) {
    case PTextTheme.standard:
      return theme.textTheme;
    case PTextTheme.primary:
      return theme.primaryTextTheme;
    case PTextTheme.accent:
      return theme.accentTextTheme;
  }
  return null; // unreachable
}

class TextTrait {
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextTheme textTheme;

  const TextTrait({@required this.textStyle, @required this.textAlign, @required this.textTheme});
}

TraitLibrary _traitLibrary = TraitLibrary();

TraitLibrary get traitLibrary => _traitLibrary;
