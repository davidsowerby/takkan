import 'package:flutter/material.dart';
import 'package:precept_client/library/part_library.dart';
import 'package:precept_client/trait/email_signin.dart';
import 'package:precept_client/trait/list.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_client/trait/query.dart';
import 'package:precept_client/trait/text.dart';
import 'package:precept_client/trait/text_box.dart';
import 'package:precept_script/part/list_view.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/part/query_view.dart';
import 'package:precept_script/part/text.dart';
import 'package:precept_script/particle/text_box.dart';
import 'package:precept_script/signin/sign_in.dart';
import 'package:precept_script/trait/text_trait.dart';

class TraitLibrary {
  Trait findParticleTrait(
      {required ThemeData theme,
      required String traitName,
      PTextTheme textBackground = PTextTheme.cardCanvas}) {
    switch (traitName) {
      case PEmailSignIn.defaultTrait:
        return EmailSignInTrait();

      case PText.title:
        final textTheme = _lookupTextTheme(theme, textBackground);

        return TextTrait(alignment: AlignmentDirectional.center,
          textStyle: textTheme.headline3!,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case PText.subtitle:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(alignment: AlignmentDirectional.center,
          textStyle: textTheme.headline5!,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case PText.strapText:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(alignment: AlignmentDirectional.center,
          textStyle: textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case PText.heading1:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline4!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case PText.heading2:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline5!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case PText.heading3:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline6!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case PText.body:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.bodyText1!,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
      case PText.defaultReadTrait:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.bodyText1!,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
      case PText.errorText:
        final textTheme = theme.textTheme;
        return TextTrait(
          textStyle: textTheme.bodyText1!.copyWith(color: Colors.red),
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );

      case PNavButton.defaultReadTrait:
        return NavButtonTrait();
      case PNavButtonSet.defaultReadTrait:
        return NavButtonSetTrait();
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
        return NoTrait(viewDataType: String, traitName: traitName);
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
}

abstract class Trait {
  final bool showCaption;
  final AlignmentGeometry alignment;

  const Trait({this.showCaption = true, required this.alignment});
}

TraitLibrary _traitLibrary = TraitLibrary();

TraitLibrary get traitLibrary => _traitLibrary;

/// Used when a Particle does not use a Trait.  Also useful to speed things up during early stage
/// development.  [viewDataType] describes the data type used by the Particle.  [traitName] is used
/// as a qualifier so that the [PartLibrary] can construct the correct widget.
class NoTrait extends Trait {
  final Type viewDataType;
  final String traitName;

  const NoTrait({
    required this.viewDataType,
    required this.traitName,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
  }) : super(
          showCaption: false,
          alignment: alignment,
        );
}
