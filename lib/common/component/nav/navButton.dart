import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/data/connectorBuilder.dart';
import 'package:precept_script/part/part.dart';
import 'package:precept_script/particle/navigation.dart';

class NavigationButton extends StatelessWidget with ConnectorBuilder  {
  final PPart partConfig;
  final ModelConnector connector;

  NavigationButton({
    Key key,
    this.partConfig,
    this.connector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigateTo(context),
      child: Text(connector.readFromModel()),
    );
  }

  navigateTo(BuildContext context) {
    final PNavParticle config = partConfig.read as PNavParticle;
    Navigator.pushNamed(context, config.route, arguments: config.args);
  }


}


