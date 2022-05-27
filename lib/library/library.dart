import 'package:flutter/material.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/data/cache_entry.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/navigation/nav_button.dart';
import 'package:takkan_client/part/navigation/nav_trait.dart';
import 'package:takkan_client/part/text/text_part.dart';
import 'package:takkan_client/part/trait.dart';
import 'package:takkan_script/common/exception.dart';
import 'package:takkan_script/common/log.dart';
import 'package:takkan_script/part/navigation.dart';
import 'package:takkan_script/part/part.dart';

abstract class Library {
  init(
      {Map<Type, Widget Function(Part, ModelConnector<dynamic, dynamic>)>
          entries = const {}});

  /// TODO: Not sure whether this is still needed?
  Widget constructPart({
    required ThemeData theme,
    required Part config,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    required Map<String, dynamic> pageArguments,
  });
}

class DefaultLibrary implements Library {
  init(
      {Map<Type, Widget Function(Part, ModelConnector<dynamic, dynamic>)>
          entries = const {}}) {}

  /// TODO: Not sure whether this is still needed?
  Widget constructPart({
    required ThemeData theme,
    required Part config,
    required DataContext dataContext,
    required DataBinding parentDataBinding,
    required Map<String, dynamic> pageArguments,
  }) {
    final trait = traitLibrary.find(
        config: config, theme: theme); // TODO: traitKey to be defined in config
    switch (trait.partName) {
      case 'TextPart':
        return TextPartBuilder().createPart(
            config: config,
            theme: theme,
            dataContext: dataContext,
            parentDataBinding: parentDataBinding);
      case 'NavButtonPart':
        return NavButtonPartBuilder().createPart(
            config: config as NavButton,
            theme: theme,
            dataContext: dataContext,
            parentDataBinding: parentDataBinding);
    }
    String msg = 'Part \'${trait.partName}\'not defined';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }
}

Library _library = DefaultLibrary();

Library get library => _library;

abstract class TraitLibrary {
  Trait find({required Part config, required ThemeData theme});
}

class DefaultTraitLibrary implements TraitLibrary {
  final List<TraitSpec> specs = List.empty(growable: true);

  DefaultTraitLibrary() {
    specs.add(
        DefaultTraitSpec()); // TODO: this may need to be combined with user supplied specs
  }

  Trait find({required Part config, required ThemeData theme}) {
    for (TraitSpec spec in specs) {
      final result = spec.find(config: config.traitName, theme: theme);
      if (result != null) return result;
    }
    String msg = 'Trait key \'${config.traitName}\' has not be defined';
    logType(this.runtimeType).e(msg);
    throw TakkanException(msg);
  }
}

abstract class TraitSpec {
  Trait? find({required String config, required ThemeData theme});
}

class DefaultTraitSpec implements TraitSpec {
  @override
  Trait? find({required String config, required ThemeData theme}) {
    switch (config) {
      case 'BodyText1':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.bodyText1!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'BodyText2':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.bodyText2!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Heading1':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.headline3!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Heading2':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.headline4!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Heading3':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.headline5!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Heading4':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.headline6!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Heading5':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.centerStart,
            textStyle: theme.textTheme.headlineSmall!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Subtitle':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.center,
            textStyle: theme.textTheme.headline4!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Subtitle2':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.center,
            textStyle: theme.textTheme.bodyText2!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'Title':
        return TextTrait(
          partName: 'TextPart',
          readTrait: ReadTextTrait(
            alignment: AlignmentDirectional.center,
            textStyle: theme.textTheme.headline3!,
            textAlign: TextAlign.center,
            textTheme: theme.textTheme,
          ),
          editTrait: EditTextTrait(
            showCaption: true,
            alignment: AlignmentDirectional.centerStart,
          ),
        );
      case 'NavButton':
        return NavButtonTrait(
          partName: 'NavButtonPart',
          readTrait: ReadNavButtonTrait(
            alignment: AlignmentDirectional.center,
          ),
        );

      default:
        return null;
    }
  }
}

TraitLibrary _traitLibrary = DefaultTraitLibrary();

TraitLibrary get traitLibrary => _traitLibrary;
