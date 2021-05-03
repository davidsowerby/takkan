import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/common/component/nav/navButton.dart';
import 'package:precept_client/trait/navigation.dart';
import 'package:precept_script/part/navigation.dart';

class NavigationButtonSet extends StatelessWidget {
  final PNavButtonSet config;
  final NavigationButtonSetTrait trait;
  final NavigationButtonTrait buttonTrait;
  final Map<String, dynamic> pageArguments;

  const NavigationButtonSet(
      {Key key,
      @required this.config,
      @required this.buttonTrait,
      @required this.trait,
      this.pageArguments = const {}})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List.empty(growable: true);
    config.buttons.forEach((key, value) {
      final PNavButton config = PNavButton(route: value, staticData: key);
      final ModelConnector connector = StaticConnector(key);
      final child = NavigationButton(
        pageArguments: pageArguments,
        connector: connector,
        partConfig: config,
      );
      children.add(child);
    });
    return Container(
        width: trait.width,
        height: trait.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ));
  }
}
