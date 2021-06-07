import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/common/component/nav/navButton.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_script/part/navigation.dart';

class NavButtonSet extends StatelessWidget {
  final PNavButtonSet config;
  final NavButtonSetTrait trait;
  final NavButtonTrait buttonTrait;
  final Map<String, dynamic> pageArguments;

  const NavButtonSet(
      {Key? key,
      required this.config,
      this.buttonTrait = const NavButtonTrait(),
      required this.trait,
      this.pageArguments = const {}})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List.empty(growable: true);
    config.buttons.forEach((key, value) {
      final PNavButton config = PNavButton(route: value, staticData: key);
      final ModelConnector connector = StaticConnector(key);
      final child = NavButton(
        pageArguments: pageArguments,
        connector: connector,
        partConfig: config,
        trait: buttonTrait,
        containedInSet: true,
      );
      children.add(child);
    });
    return Row(
      children: [
        Spacer(),
        Container(
          width: config.width ?? trait.width,
          height: trait.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
