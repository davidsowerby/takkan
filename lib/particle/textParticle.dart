import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/converter.dart';
import 'package:precept_client/data/connectorBuilder.dart';
import 'package:precept_client/particle/particle.dart';
import 'package:precept_client/widget/caption.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/script.dart';

class TextParticle extends StatelessWidget with ConnectorBuilder implements Particle {
  final PPart config;
  final ModelConnector connector;

  const TextParticle({Key key, @required this.config, @required this.connector}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        Text((config.isStatic == IsStatic.yes) ? config.staticData : connector.readFromModel());
    if (config.read.showCaption) {
      return Container(
        height: config.particleHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Caption(
                text: config.caption,
              ),
            ),
            text,
          ],
        ),
      );
    }
    return Container(height: config.particleHeight, child: text);
  }

  @override
  Type get viewDataType => String;
}
