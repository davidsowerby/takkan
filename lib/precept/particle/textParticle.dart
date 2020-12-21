import 'package:flutter/widgets.dart';
import 'package:precept_client/precept/binding/converter.dart';
import 'package:precept_client/precept/particle/particle.dart';
import 'package:precept_client/precept/widget/caption.dart';
import 'package:precept_script/script/part/pString.dart';

class TextParticle extends StatelessWidget implements Particle {
  final ModelConnector modelConnector;
  final PString config;
  final bool isStatic;

  const TextParticle({Key key, this.modelConnector, @required this.config, this.isStatic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text=Text((isStatic) ? config.staticData : modelConnector.readFromModel());
    if (config.readModeOptions.showCaption) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 51, // difference between read only and edit widgets
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Caption(
                  text: config.caption,
                ),
              ),
              Text((isStatic) ? config.staticData : modelConnector.readFromModel()),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: text,
    );
  }
}
