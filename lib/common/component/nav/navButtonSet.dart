import 'package:flutter/widgets.dart';
import 'package:precept_client/binding/connector.dart';
import 'package:precept_client/common/component/nav/navButton.dart';
import 'package:precept_script/part/navigation.dart';
import 'package:precept_script/particle/navigation.dart';

class NavigationButtonSet extends StatelessWidget {
  final PNavButtonSet config;

  const NavigationButtonSet({Key key, @required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List.empty(growable: true);
    final PNavButtonSetParticle buttonConfig=config.read;
    buttonConfig.buttons.forEach((key, value) {
      final PNavPart config = PNavPart(route: value, staticData: key);
      final ModelConnector connector = StaticConnector(key);
      final child = NavigationButton(
        connector: connector,
        partConfig: config,
      );
      children.add(child);
    });
    return Container(
        width: buttonConfig.width,
        height: buttonConfig.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ));
  }
}
