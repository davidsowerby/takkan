import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/data/connectorBuilder.dart';
import 'package:precept_client/particle/particle.dart';
import 'package:precept_script/script/pPart.dart';
import 'package:precept_script/script/particle/navigation.dart';


class NavigationButton extends StatelessWidget with ConnectorBuilder implements Particle {
  final PPart partConfig;
  final ModelConnector connector;

  NavigationButton({
    Key key,
    this.partConfig,
    this.connector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Expanded(child: Container()),
        ElevatedButton(
          onPressed: () => navigateTo(context),
          child: Text(connector.readFromModel()),
        ),
        Expanded(child: Container(),),],
    );
  }

  navigateTo(BuildContext context) {
    final PNavParticle config = partConfig.read as PNavParticle;
    Navigator.pushNamed(context, config.route, arguments: config.args);
  }

  @override
  Type get viewDataType => String;
}
