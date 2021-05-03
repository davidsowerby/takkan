import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/data/connectorBuilder.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_script/part/navigation.dart';

class NavigationButton extends StatelessWidget with ConnectorBuilder  {
  final PNavButton partConfig;
  final ModelConnector connector;
  final NavigationButtonTrait trait;
  final Map<String, dynamic> pageArguments;

  NavigationButton({
    Key key,
    this.partConfig,
    this.connector,
    this.trait,
    this.pageArguments=const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigateTo(context),
      child: Text(connector.readFromModel()),
    );
  }

  navigateTo(BuildContext context) {
    Navigator.pushNamed(context, partConfig.route, arguments: pageArguments);
  }


}


