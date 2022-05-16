import 'package:flutter/material.dart';
import 'package:takkan_client/binding/connector.dart';
import 'package:takkan_client/common/component/heading.dart';
import 'package:takkan_client/trait/text_box.dart';
import 'package:takkan_script/part/part.dart';

class TextBoxParticle extends StatelessWidget {
  final TextBoxTrait trait;
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
          labelStyle: theme.textTheme.overline?.apply(color: theme.primaryColor),
          labelText: partConfig.caption,
          border: OutlineInputBorder(gapPadding: 0),
        ),
      ),
    );
  }
}
