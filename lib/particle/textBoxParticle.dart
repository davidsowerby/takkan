import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_script/part/part.dart';

class TextBoxParticle extends StatelessWidget {
  final PPart config;
  final ModelConnector connector;

  TextBoxParticle({Key key, @required this.config, @required this.connector});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: connector.readFromModel(),
      validator: (inputData) => connector.validate(inputData, config.script),
      onSaved: (inputData) => connector.writeToModel(inputData),
      decoration: InputDecoration(
        isDense: true,
        labelStyle: theme.textTheme.overline.apply(color: theme.primaryColor),
        labelText: config.caption,
        border: OutlineInputBorder(gapPadding: 0),
      ),
    );
  }
}
