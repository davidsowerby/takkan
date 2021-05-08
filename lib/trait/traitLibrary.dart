import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:precept_client/trait/list.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_client/trait/query.dart';
import 'package:precept_client/trait/text.dart';
import 'package:precept_client/trait/textBox.dart';
import 'package:precept_script/common/exception.dart';
import 'package:precept_script/common/log.dart';
import 'package:precept_script/part/listView.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/part/queryView.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/particle/textBox.dart';
import 'package:precept_script/trait/textTrait.dart';

class TraitLibrary {
  Trait findParticleTrait(
      {@required ThemeData theme,
      @required String traitName,
      @required PPart partConfig,
      PTextTheme textBackground = PTextTheme.cardCanvas}) {
    switch (traitName) {
      case PText.heading1:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline4,
          textAlign: TextAlign.center,
          textTheme: textTheme,
          caption: partConfig.caption,
        );
      case PText.heading2:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline5,
          textAlign: TextAlign.center,
          textTheme: textTheme,
          caption: partConfig.caption,
        );
      case PText.heading3:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline6,
          textAlign: TextAlign.center,
          textTheme: textTheme,
          caption: partConfig.caption,
        );
      case PText.defaultReadTrait:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.bodyText1,
          textAlign: TextAlign.left,
          textTheme: textTheme,
          caption: partConfig.caption,
        );
      case PNavButton.defaultReadTrait:
        return NavigationButtonTrait();
      case PNavButtonSet.defaultReadTrait:
        return NavigationButtonSetTrait();
      case PTextBox.defaultTraitName:
        return TextBoxTrait();
      case PListView.defaultReadTrait:
        return ListViewReadTrait();
      case PListView.defaultEditTrait:
        return ListViewEditTrait();
      case PListView.defaultItemReadTrait:
        return ListItemReadTrait();
      case PListView.defaultItemEditTrait:
        return ListItemEditTrait();
      case PQueryView.defaultReadTrait:
        return QueryViewReadTrait();
      case PQueryView.defaultEditTrait:
        return QueryViewEditTrait();
      case PQueryView.defaultItemReadTrait:
        return QueryItemReadTrait();
      case PQueryView.defaultItemEditTrait:
        return QueryItemEditTrait();
      default:
        String msg = "Trait name: '$traitName' has not be registered in the Trait Library";
        logType(this.runtimeType).e(msg);
        throw PreceptException(msg);
    }
  }
}

TextTheme _lookupTextTheme(ThemeData theme, PTextTheme background) {
  switch (background) {
    case PTextTheme.cardCanvas:
      return theme.textTheme;
    case PTextTheme.primary:
      return theme.primaryTextTheme;
    case PTextTheme.accent:
      return theme.accentTextTheme;
  }
  return null; // unreachable
}

abstract class Trait {
  final bool showCaption;
  final String caption;

  const Trait({this.showCaption = true, this.caption});

  Type get viewDataType;
}

TraitLibrary _traitLibrary = TraitLibrary();

TraitLibrary get traitLibrary => _traitLibrary;
