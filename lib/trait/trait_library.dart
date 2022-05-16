import 'package:flutter/material.dart';
import 'package:takkan_client/library/part_library.dart';
import 'package:takkan_client/trait/email_signin.dart';
import 'package:takkan_client/trait/list.dart';
import 'package:takkan_client/trait/navigation.dart';
import 'package:takkan_client/trait/query.dart';
import 'package:takkan_client/trait/text.dart';
import 'package:takkan_client/trait/text_box.dart';
import 'package:takkan_script/part/list_view.dart' as ListViewConfig;
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/query_view.dart';
import 'package:takkan_script/part/text.dart' as TextConfig;
import 'package:takkan_script/particle/text_box.dart' as TextBoxConfig;
import 'package:takkan_script/signin/sign_in.dart';
import 'package:takkan_script/trait/text_trait.dart' as TextTraitConfig;

class TraitLibrary {
  Trait findParticleTrait(
      {required ThemeData theme,
      required String traitName,
      TextTraitConfig.TextTheme textBackground =
          TextTraitConfig.TextTheme.cardCanvas}) {
    switch (traitName) {
      case EmailSignIn.defaultTrait:
        return EmailSignInTrait();

      case TextConfig.Text.title:
        final textTheme = _lookupTextTheme(theme, textBackground);

        return TextTrait(
          alignment: AlignmentDirectional.center,
          textStyle: textTheme.headline3!,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case TextConfig.Text.subtitle:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          alignment: AlignmentDirectional.center,
          textStyle: textTheme.headline5!,
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case TextConfig.Text.strapText:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          alignment: AlignmentDirectional.center,
          textStyle: textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );
      case TextConfig.Text.heading1:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline4!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case TextConfig.Text.heading2:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline5!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case TextConfig.Text.heading3:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.headline6!,
          textAlign: TextAlign.start,
          textTheme: textTheme,
        );
      case TextConfig.Text.body:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.bodyText1!,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
      case TextConfig.Text.defaultReadTrait:
        final textTheme = _lookupTextTheme(theme, textBackground);
        return TextTrait(
          textStyle: textTheme.bodyText1!,
          textAlign: TextAlign.left,
          textTheme: textTheme,
        );
      case TextConfig.Text.errorText:
        final textTheme = theme.textTheme;
        return TextTrait(
          textStyle: textTheme.bodyText1!.copyWith(color: Colors.red),
          textAlign: TextAlign.center,
          textTheme: textTheme,
        );

      case NavButton.defaultReadTrait:
        return NavButtonTrait();
      case NavButtonSet.defaultReadTrait:
        return NavButtonSetTrait();
      case TextBoxConfig.TextBox.defaultTraitName:
        return TextBoxTrait();
      case ListViewConfig.ListView.defaultReadTrait:
        return ListViewReadTrait();
      case ListViewConfig.ListView.defaultEditTrait:
        return ListViewEditTrait();
      case ListViewConfig.ListView.defaultItemReadTrait:
        return ListItemReadTrait();
      case ListViewConfig.ListView.defaultItemEditTrait:
        return ListItemEditTrait();
      case QueryView.defaultReadTrait:
        return QueryViewReadTrait();
      case QueryView.defaultEditTrait:
        return QueryViewEditTrait();
      case QueryView.defaultItemReadTrait:
        return QueryItemReadTrait();
      case QueryView.defaultItemEditTrait:
        return QueryItemEditTrait();
      default:
        return NoTrait(viewDataType: String, traitName: traitName);
    }
  }
}

TextTheme _lookupTextTheme(
    ThemeData theme, TextTraitConfig.TextTheme background) {
  switch (background) {
    case TextTraitConfig.TextTheme.cardCanvas:
      return theme.textTheme;
    case TextTraitConfig.TextTheme.primary:
      return theme.primaryTextTheme;
    case TextTraitConfig.TextTheme.accent:
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
