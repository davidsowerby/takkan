import 'package:flutter/material.dart';

import '../part/navigation/nav_trait.dart';
import '../part/text/text_part.dart';
import '../part/trait.dart';
import 'trait_library.dart';

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
