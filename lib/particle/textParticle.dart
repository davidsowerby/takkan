import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/trait/text.dart';
import 'package:precept_client/widget/caption.dart';
import 'package:precept_script/part/part.dart';

class TextParticle extends StatelessWidget  {
  final TextTrait trait;
  final PPart partConfig;

  final ModelConnector connector;

  const TextParticle({Key? key, required this.trait, required this.connector, required this.partConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = Text(
      connector.readFromModel(),
      style: trait.textStyle,
      textAlign: trait.textAlign,
    );
    if (partConfig.caption !=null && trait.showCaption) {
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
            text,
          ],
        ),
      );
    }
    return Container(height: partConfig.height, child: text);
  }


}
