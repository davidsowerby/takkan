import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/trait/textBox.dart';
import 'package:precept_script/part/part.dart';

class TextBoxParticle extends StatelessWidget {
  final TextBoxTrait trait;
  final PPart partConfig;
  final ModelConnector connector;

  const TextBoxParticle({Key key, @required this.partConfig, @required this.connector,@required this.trait});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: connector.readFromModel(),
      validator: (inputData) => connector.validate(inputData, partConfig.script),
      onSaved: (inputData) => connector.writeToModel(inputData),
      decoration: InputDecoration(
        isDense: true,
        labelStyle: theme.textTheme.overline.apply(color: theme.primaryColor),
        labelText: partConfig.caption,
        border: OutlineInputBorder(gapPadding: 0),
      ),
    );
  }
}
