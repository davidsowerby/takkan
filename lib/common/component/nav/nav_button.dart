import 'package:flutter/material.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_script/part/navigation.dart';

class NavButton extends StatelessWidget  {
  final PNavButton partConfig;
  final ModelConnector connector;
  final NavButtonTrait trait;
  final Map<String, dynamic> pageArguments;
final bool containedInSet;
  NavButton({
    Key? key,
    this.containedInSet=false,
    required this.partConfig,
    required this.connector,
    this.trait=const NavButtonTrait(),
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
