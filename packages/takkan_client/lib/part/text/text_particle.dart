import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takkan_client/data/binding/connector.dart';
import 'package:takkan_client/common/component/heading.dart';
import 'package:takkan_client/common/interpolate.dart';
import 'package:takkan_client/data/data_source.dart';
import 'package:takkan_client/part/text/text_part.dart';
import 'package:takkan_client/common/component/caption.dart';
import 'package:takkan_script/part/part.dart';

class TextParticle extends StatelessWidget {
  final ReadTextTrait trait;
  final Part partConfig;
  final ModelConnector? connector;
  final ParticleInterpolator interpolator;

  const TextParticle({
    Key? key,
    required this.trait,
    required this.connector,
    required this.partConfig,
    required this.interpolator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      interpolator.interpolate(),
      style: trait.textStyle,
      textAlign: trait.textAlign,
    );
    if (partConfig.caption != null && trait.showCaption) {
      return Container(
        height: partConfig.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Caption(
                text: partConfig.caption!,
                help: partConfig.help,
              ),
            ),
            textWidget,
          ],
        ),
      );
    }

    return Container(
        alignment: trait.alignment,
        height: partConfig.height,
        child: textWidget);
  }
}

class TextBoxParticle extends StatelessWidget {
  final EditTextTrait trait;
  final Part partConfig;
  final ModelConnector connector;

  const TextBoxParticle(
      {Key? key,
      required this.partConfig,
      required this.connector,
      required this.trait});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: trait.alignment,
      child: TextFormField(
        initialValue: connector.readFromModel(),
        validator: (inputData) => connector.validate(inputData),
        onSaved: (inputData) => connector.writeToModel(inputData),
        decoration: InputDecoration(
          suffixIcon: (partConfig.help == null)
              ? null
              : HelpButton(
                  help: partConfig.help!,
                ),
          isDense: true,
          labelStyle:
              theme.textTheme.overline?.apply(color: theme.primaryColor),
          labelText: partConfig.caption,
          border: OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}

/// Interpolates [partConfig.staticData] with values obtained via the [connector], user
/// information or system information (see [sourceData] for methods of retrieval)
///
/// If there is no dynamic data, that is, partConfig.isStatic==true, then
/// [partConfig.staticData] is still passed for interpolation, as it may contain
/// references to user or system data.
///
/// If called with [partConfig.staticData]==null, returns the value from [connector],
/// in which case [connector] cannot be null (and will not be if validate has been
/// run on the Script.
///
class ParticleInterpolator with Interpolator {
  final Part partConfig;
  final ModelConnector? connector;
  final DataContext dataContext;

  const ParticleInterpolator(
      {required this.partConfig, this.connector, required this.dataContext});

  String interpolate() {
    if (partConfig.isStatic)
      return doInterpolate(partConfig.staticData!, (key) => sourceData(key));
    if (partConfig.staticData == null) return connector!.readFromModel();
    final String pattern = partConfig.staticData!;
    if (connector == null) return pattern;
    return doInterpolate(pattern, (key) => sourceData(key));
  }

  String sourceData(String key) {
    final chars = key.characters;
    if (chars.startsWith('#'.characters)) {
      final range = chars.findFirst('#'.characters)!;
      range.moveUntil('.'.characters);
      final source = range.currentCharacters.string;
      range.moveNext(1);

      switch (source) {
        case 'user':
          {
            if (dataContext.dataProvider.userIsNotAuthenticated) return '?';
            final userAttribute = range.charactersAfter.string;
            return dataContext.dataProvider.user.data[userAttribute] ?? '?';
          }
        case 'system':
          {
            final systemAttribute = range.charactersAfter.string;
            switch (systemAttribute) {
              case 'date':
                {
                  final df = DateFormat.yMd();
                  return df.format(DateTime.now());
                }
            }
            // Could use Platform here, but not sure what is needed
            return 'system value';
          }
        default:
          return '?';
      }
    }
    if (partConfig.isStatic) return '?';

    /// From empty key in static data, example: 'Your score is {}', this requires
    /// property is set
    if (key == '') return connector?.readFromModel();
    return connector!.binding.parent!.read()[key] ?? '?';
  }
}
