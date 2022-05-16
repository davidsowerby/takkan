import 'package:flutter/material.dart';
import 'package:takkan_client/binding/connector.dart';
import 'package:takkan_client/trait/navigation.dart';
import 'package:takkan_script/part/navigation.dart';

class NavButtonWidget extends StatelessWidget {
  final NavButton partConfig;
  final ModelConnector connector;
  final NavButtonTrait trait;
  final Map<String, dynamic> pageArguments;
  final bool containedInSet;

  NavButtonWidget({
    Key? key,
    this.containedInSet = false,
    required this.partConfig,
    required this.connector,
    this.trait = const NavButtonTrait(),
    this.pageArguments = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button=
     ElevatedButton(
       onPressed: () => navigateTo(context),
       child: Text(connector.readFromModel()),
     );
    return (containedInSet) ? button : Container(alignment: trait.alignment,child: button);
  }

  navigateTo(BuildContext context) {
    Navigator.pushNamed(context, partConfig.route, arguments: pageArguments);
  }
}
