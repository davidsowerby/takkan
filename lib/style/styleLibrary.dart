import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:precept_script/script/trait/textTrait.dart';

class StyleLibrary {

  TextStyle textStyle(ThemeData theme, PTextTrait trait){
    switch (trait.textStyle) {
      case PTextStyle.headline1:
        return theme.textTheme.headline1;
      case PTextStyle.headline2:
        return theme.textTheme.headline2;
      case PTextStyle.headline3:
        return theme.textTheme.headline3;
      case PTextStyle.headline4:
        return theme.textTheme.headline4;
      case PTextStyle.headline5:
        return theme.textTheme.headline5;
      case PTextStyle.headline6:
        return theme.textTheme.headline6;
      case PTextStyle.subtitle1:
        return theme.textTheme.subtitle1;
      case PTextStyle.subtitle2:
        return theme.textTheme.subtitle2;
      case PTextStyle.bodyText1:
        return theme.textTheme.bodyText1;
      case PTextStyle.bodyText2:
        return theme.textTheme.bodyText2;
      case PTextStyle.caption:
        return theme.textTheme.caption;
      case PTextStyle.button:
        return theme.textTheme.button;
      case PTextStyle.overline:
        return theme.textTheme.overline;
    }
    return null;//unreachable
  }

  /// This seems pointless, converting one enum to another. It is only done to avoid having Flutter as a
  /// dependency to the *precept_script* package.
  TextAlign textAlign(PTextTrait trait){
    switch (trait.textAlign){

      case PTextAlign.left:
        return TextAlign.left;
      case PTextAlign.right:
        return TextAlign.right;
      case PTextAlign.center:
        return TextAlign.center;
      case PTextAlign.justify:
        return TextAlign.justify;
      case PTextAlign.start:
        return TextAlign.start;
      case PTextAlign.end:
        return TextAlign.end;
    }
    return null;//unreachable
  }


}






StyleLibrary _styleLibrary= StyleLibrary();
StyleLibrary get styleLibrary=>_styleLibrary;

